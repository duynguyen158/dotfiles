#!/usr/bin/env bash
set -euo pipefail

# herdr-studiomp: Connect or reattach to remote Studio persistent Herdr session running OMP
# Managed by ~/.dotfiles/caro/nix/home-manager/

usage() {
  cat <<'EOF'
Usage: studiomp [OPTIONS]

Connect or reattach to the remote Studio persistent Herdr session running OMP.

Options:
  --attach    Attach directly to the remote OMP agent terminal stream via SSH
  --tui       Attach the laptop native Herdr controller TUI (outside Herdr only)
  -h, --help  Show this help message

Default behavior:
  Inside Herdr (HERDR_ENV=1): Defaults to direct agent attach (--attach) to avoid nested TUI violation.
  Outside Herdr (normal terminal): Defaults to laptop native controller TUI (--tui).
EOF
}

explicit_attach=false
explicit_tui=false

while [ $# -gt 0 ]; do
  case "$1" in
    --attach)
      explicit_attach=true
      shift
      ;;
    --tui)
      explicit_tui=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option '$1'" >&2
      echo "Run 'studiomp --help' for usage." >&2
      exit 2
      ;;
  esac
done

if [ "$explicit_attach" = true ] && [ "$explicit_tui" = true ]; then
  echo "error: cannot specify both --attach and --tui" >&2
  exit 2
fi

# 1. Determine execution mode and reject nested TUI upfront before any network/API calls
mode="auto"
if [ "$explicit_attach" = true ]; then
  mode="attach"
elif [ "$explicit_tui" = true ]; then
  mode="tui"
fi

if [ "$mode" = "auto" ]; then
  if [ "${HERDR_ENV:-}" = "1" ]; then
    mode="attach"
  else
    mode="tui"
  fi
fi

if [ "$mode" = "tui" ] && [ "${HERDR_ENV:-}" = "1" ]; then
  echo "error: nested Herdr controller TUI is disabled inside Herdr (HERDR_ENV=1)." >&2
  echo "Action required: Run from a normal terminal outside Herdr, or use direct agent attach (studiomp --attach)." >&2
  exit 1
fi

# Ensure required local utilities are present
for cmd in herdr jq ssh; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: '$cmd' executable not found in PATH" >&2
    exit 1
  fi
done

# 2. Validate machine registration in Caro Herdr
if ! machines_raw=$(herdr machine list --json 2>&1); then
  echo "error: failed to list Herdr machines: $machines_raw" >&2
  exit 1
fi

if ! echo "$machines_raw" | jq . >/dev/null 2>&1; then
  echo "error: 'herdr machine list --json' returned invalid JSON: $machines_raw" >&2
  exit 1
fi

matching_profiles=$(echo "$machines_raw" | jq -c '[.[] | select(.label == "Studio" and .enabled == true)]')
match_count=$(echo "$matching_profiles" | jq 'length')

if [ "$match_count" -eq 0 ]; then
  echo "error: Herdr machine 'Studio' is not registered or is disabled in Caro Herdr." >&2
  echo "Action required: Run 'herdr machine add studio --label Studio --remote-session studiomp' in an interactive terminal to register it." >&2
  exit 1
elif [ "$match_count" -gt 1 ]; then
  echo "error: multiple enabled Herdr machines with label 'Studio' found; ambiguous profile configuration." >&2
  exit 1
fi

# Validate target and session match expected values
profile_target=$(echo "$matching_profiles" | jq -r '.[0].target')
profile_session=$(echo "$matching_profiles" | jq -r '.[0].session')
profile_id=$(echo "$matching_profiles" | jq -r '.[0].id')

if [ "$profile_target" != "studio" ] || [ "$profile_session" != "studiomp" ]; then
  echo "error: machine profile 'Studio' configuration mismatch (target='$profile_target', session='$profile_session'; expected target='studio', session='studiomp')." >&2
  exit 1
fi

if [ -z "$profile_id" ] || [ "$profile_id" = "null" ]; then
  echo "error: machine profile 'Studio' missing valid opaque ID." >&2
  exit 1
fi

# 3. Verify remote server is running on Studio
if ! server_status_raw=$(herdr --machine "$profile_id" status server --json 2>&1); then
  echo "error: failed to query Herdr server status on Studio: $server_status_raw" >&2
  echo "For SSH authentication, run 'herdr machine reconnect Studio' in an interactive terminal. For a stopped server, run 'herdr --remote studio --session studiomp' from a terminal outside Herdr." >&2
  exit 1
fi

if ! echo "$server_status_raw" | jq . >/dev/null 2>&1; then
  echo "error: 'herdr --machine $profile_id status server --json' returned invalid JSON: $server_status_raw" >&2
  exit 1
fi

server_status=$(echo "$server_status_raw" | jq -r '.status // empty')
if [ "$server_status" != "running" ]; then
  echo "error: Herdr server is not running on Studio session 'studiomp' (status='$server_status')." >&2
  echo "Start the session with 'herdr --remote studio --session studiomp' from a terminal outside Herdr, then retry studiomp. Do not replace a running server or stop its panes." >&2
  exit 1
fi

# Resolve on Studio: Herdr reports physical cwd paths, including symlink targets.
if ! remote_projects=$(ssh studio 'cd "$HOME/Projects" && pwd -P' 2>&1); then
  echo "error: failed to resolve remote Projects directory via SSH alias studio: $remote_projects" >&2
  exit 1
fi

# 5. Check for existing 'studiomp' agent and refuse foreign collisions
if ! agents_raw=$(herdr --machine "$profile_id" agent list 2>&1); then
  echo "error: failed to query agents on Studio: $agents_raw" >&2
  exit 1
fi

if ! echo "$agents_raw" | jq . >/dev/null 2>&1; then
  echo "error: 'herdr --machine $profile_id agent list' returned invalid JSON: $agents_raw" >&2
  exit 1
fi

matching_agents=$(echo "$agents_raw" | jq -c '[.result.agents[]? | select(.name == "studiomp")]')
agent_count=$(echo "$matching_agents" | jq 'length')

if [ "$agent_count" -gt 1 ]; then
  echo "error: multiple agents named 'studiomp' found on remote session; refusing ambiguous state." >&2
  exit 1
elif [ "$agent_count" -eq 1 ]; then
  agent_kind=$(echo "$matching_agents" | jq -r '.[0].agent // empty')
  if [ "$agent_kind" != "omp" ]; then
    echo "error: agent 'studiomp' exists on Studio but has kind '$agent_kind' (expected 'omp'). Refusing collision with foreign agent." >&2
    exit 1
  fi
  agent_cwd=$(echo "$matching_agents" | jq -r '.[0].cwd // empty')
  case "$agent_cwd" in
    "$remote_projects"|"$remote_projects/"|"~/Projects"|"~/Projects/") ;;
    *)
      echo "error: agent 'studiomp' exists on Studio but has cwd '$agent_cwd' (expected '$remote_projects'). Refusing collision with foreign agent." >&2
      exit 1
      ;;
  esac
  # Agent exists, kind is omp, cwd is remote Projects, exactly 1 instance: ready to attach.
else
  # 6. Agent does not exist; find or create dedicated workspace with remote '~/Projects'
  if ! workspaces_raw=$(herdr --machine "$profile_id" workspace list 2>&1); then
    echo "error: failed to query workspaces on Studio: $workspaces_raw" >&2
    exit 1
  fi

  if ! echo "$workspaces_raw" | jq . >/dev/null 2>&1; then
    echo "error: 'herdr --machine $profile_id workspace list' returned invalid JSON: $workspaces_raw" >&2
    exit 1
  fi

  matching_workspaces=$(echo "$workspaces_raw" | jq -c '[.result.workspaces[]? | select(.label == "studiomp")]')
  ws_count=$(echo "$matching_workspaces" | jq 'length')

  if [ "$ws_count" -gt 1 ]; then
    echo "error: multiple workspaces with label 'studiomp' found on remote session; refusing ambiguous state." >&2
    exit 1
  fi

  target_pane=""
  if [ "$ws_count" -eq 0 ]; then
    # Herdr 0.9.3 does not expand tilde in workspace API arguments.
    if ! ws_create_raw=$(herdr --machine "$profile_id" workspace create --cwd "$remote_projects" --label 'studiomp' --no-focus 2>&1); then
      echo "error: failed to create dedicated workspace 'studiomp' on Studio: $ws_create_raw" >&2
      exit 1
    fi
    if ! echo "$ws_create_raw" | jq . >/dev/null 2>&1; then
      echo "error: workspace create returned invalid JSON: $ws_create_raw" >&2
      exit 1
    fi
    target_pane=$(echo "$ws_create_raw" | jq -r '.result.root_pane.pane_id // empty')
    if [ -z "$target_pane" ]; then
      echo "error: workspace create response missing root_pane.pane_id: $ws_create_raw" >&2
      exit 1
    fi
  else
    ws_id=$(echo "$matching_workspaces" | jq -r '.[0].workspace_id')

    # Inspect panes belonging ONLY to this dedicated workspace
    if ! panes_raw=$(herdr --machine "$profile_id" pane list --workspace "$ws_id" 2>&1); then
      echo "error: failed to list panes in workspace '$ws_id' on Studio: $panes_raw" >&2
      exit 1
    fi
    if ! echo "$panes_raw" | jq . >/dev/null 2>&1; then
      echo "error: pane list returned invalid JSON: $panes_raw" >&2
      exit 1
    fi

    # Check candidates with agent == null
    candidate_panes=$(echo "$panes_raw" | jq -r '.result.panes[]? | select(.agent == null) | .pane_id')
    for p in $candidate_panes; do
      candidate_cwd=$(echo "$panes_raw" | jq -r --arg p "$p" '.result.panes[]? | select(.pane_id == $p) | .cwd // empty')
      case "$candidate_cwd" in
        "$remote_projects"|"$remote_projects/"|"~/Projects"|"~/Projects/") ;;
        *)
          echo "error: workspace 'studiomp' pane '$p' has cwd '$candidate_cwd' (expected '$remote_projects'). Refusing workspace mismatch." >&2
          exit 1
          ;;
      esac

      if ! p_info_raw=$(herdr --machine "$profile_id" pane process-info --pane "$p" 2>&1); then
        echo "error: failed to query process-info for pane '$p' on Studio: $p_info_raw" >&2
        exit 1
      fi
      if ! echo "$p_info_raw" | jq . >/dev/null 2>&1; then
        echo "error: 'pane process-info --pane $p' returned invalid JSON: $p_info_raw" >&2
        exit 1
      fi

      shell_pid=$(echo "$p_info_raw" | jq -r '.result.process_info.shell_pid // empty')
      fg_pgid=$(echo "$p_info_raw" | jq -r '.result.process_info.foreground_process_group_id // empty')
      if [ -n "$shell_pid" ] && [ "$shell_pid" = "$fg_pgid" ]; then
        target_pane="$p"
        break
      fi
    done

    if [ -z "$target_pane" ]; then
      # No idle pane available; split with the resolved remote project path.
      first_pane=$(echo "$panes_raw" | jq -r '.result.panes[0].pane_id // empty')
      if [ -n "$first_pane" ]; then
        if ! split_raw=$(herdr --machine "$profile_id" pane split "$first_pane" --direction right --cwd "$remote_projects" --no-focus 2>&1); then
          echo "error: failed to split pane in workspace '$ws_id' on Studio: $split_raw" >&2
          exit 1
        fi
        if ! echo "$split_raw" | jq . >/dev/null 2>&1; then
          echo "error: pane split returned invalid JSON: $split_raw" >&2
          exit 1
        fi
        target_pane=$(echo "$split_raw" | jq -r '.result.pane.pane_id // empty')
      fi
    fi
  fi

  if [ -z "$target_pane" ]; then
    echo "error: could not find or allocate an idle shell pane in dedicated workspace 'studiomp' on Studio." >&2
    exit 1
  fi

  # Start the OMP agent in the dedicated workspace pane
  if ! start_raw=$(herdr --machine "$profile_id" agent start studiomp --kind omp --pane "$target_pane" 2>&1); then
    echo "error: failed to start OMP agent on Studio pane '$target_pane': $start_raw" >&2
    exit 1
  fi
fi

# 7. Attach to session
if [ "$mode" = "tui" ]; then
  # Outside Herdr: focus the studiomp agent explicitly before attaching full controller TUI
  if ! focus_raw=$(herdr --machine "$profile_id" agent focus studiomp 2>&1); then
    echo "error: failed to focus agent 'studiomp' on Studio: $focus_raw" >&2
    exit 1
  fi
  exec herdr --remote studio --session studiomp
else
  # Inside Herdr: attach directly to the agent terminal stream via SSH
  exec ssh -t studio 'exec ~/.local/bin/herdr --session studiomp agent attach studiomp'
fi
