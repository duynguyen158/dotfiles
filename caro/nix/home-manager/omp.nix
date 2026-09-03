{ pkgs, ... }:

let
  omp = pkgs.stdenv.mkDerivation {
    pname = "omp";
    version = "18.1.6";
    src = pkgs.fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v18.1.6/omp-darwin-arm64";
      hash = "sha256-XfmJgjUYnJUxkD0IXajPqDBt/iDR7WxBSVeH1PJVhx0=";
    };
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/omp
      chmod +x $out/bin/omp
    '';
  };
in
{
  home.packages = [ omp ];

  programs.zsh.initContent = ''
    omp() {
      (
        if [[ -f "$HOME/.secrets/ai_providers" ]]; then
          set -a; source "$HOME/.secrets/ai_providers"; set +a
        else
          echo "💡 Create ~/.secrets/ai_providers with your API keys (e.g. OPENAI_API_KEY=sk-...) to have them automatically available to omp."
        fi

        local aws_profile="$AWS_PROFILE"
        if [[ -n "$CONF_AWS_ACCOUNT_NAME" ]]; then
          aws_profile="omp-bedrock"
        fi
        if [[ -n "$aws_profile" ]] && command -v aws >/dev/null 2>&1; then
          export AWS_PROFILE="$aws_profile"
          if ! aws sts get-caller-identity --profile "$aws_profile" >/dev/null 2>&1; then
            echo "AWS SSO authentication failed; OMP cannot use Bedrock." >&2
            exit 1
          fi
        fi

        command omp "$@"
      )
    }
  '';

  # Source files live outside themes/ to avoid name collision (all three share "name": "night-owl").
  # The extension copies the right one to themes/night-owl.json at startup.
  home.file.".omp/agent/theme-sources/night-owl-dark.json".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/modes/theme/theme-schema.json",
      "name": "night-owl",
      "vars": {
        "bg": "#011627",
        "fg": "#d6deeb",
        "fgMuted": "#9fb3c8",
        "fgDim": "#6f8793",
        "blue": "#82aaff",
        "purple": "#c792ea",
        "green": "#c5e478",
        "teal": "#7fdbca",
        "cyan": "#89ddff",
        "yellow": "#ffeb95",
        "orange": "#f78c6c",
        "red": "#ef5350",
        "pink": "#d183e8",
        "comment": "#637777",
        "border": "#5f7e97",
        "borderMuted": "#122d42",
        "dim": "#4b6479",
        "selectedBg": "#1d3b53",
        "userMsgBg": "#0b253a",
        "toolPendingBg": "#01111d",
        "toolSuccessBg": "#021320",
        "toolErrorBg": "#2a1014",
        "customMsgBg": "#1a1130",
        "statusBg": "#03111e"
      },
      "colors": {
        "accent": "teal",
        "border": "border",
        "borderAccent": "blue",
        "borderMuted": "borderMuted",
        "success": "green",
        "error": "red",
        "warning": "yellow",
        "muted": "fgDim",
        "dim": "dim",
        "text": "fg",
        "thinkingText": "fgMuted",
        "selectedBg": "selectedBg",
        "userMessageBg": "userMsgBg",
        "userMessageText": "fg",
        "customMessageBg": "customMsgBg",
        "customMessageText": "fg",
        "customMessageLabel": "purple",
        "toolPendingBg": "toolPendingBg",
        "toolSuccessBg": "toolSuccessBg",
        "toolErrorBg": "toolErrorBg",
        "toolTitle": "fg",
        "toolOutput": "fgMuted",
        "mdHeading": "yellow",
        "mdLink": "blue",
        "mdLinkUrl": "fgDim",
        "mdCode": "cyan",
        "mdCodeBlock": "fg",
        "mdCodeBlockBorder": "border",
        "mdQuote": "fgMuted",
        "mdQuoteBorder": "border",
        "mdHr": "borderMuted",
        "mdListBullet": "teal",
        "toolDiffAdded": "green",
        "toolDiffRemoved": "red",
        "toolDiffContext": "fgDim",
        "syntaxComment": "comment",
        "syntaxKeyword": "purple",
        "syntaxFunction": "blue",
        "syntaxVariable": "green",
        "syntaxString": "#ecc48d",
        "syntaxNumber": "orange",
        "syntaxType": "#ffcb8b",
        "syntaxOperator": "teal",
        "syntaxPunctuation": "fg",
        "thinkingOff": "borderMuted",
        "thinkingMinimal": "dim",
        "thinkingLow": "blue",
        "thinkingMedium": "teal",
        "thinkingHigh": "purple",
        "thinkingXhigh": "pink",
        "bashMode": "green",
        "pythonMode": "yellow",
        "statusLineBg": "statusBg",
        "statusLineSep": "dim",
        "statusLineModel": "purple",
        "statusLinePath": "blue",
        "statusLineGitClean": "green",
        "statusLineGitDirty": "yellow",
        "statusLineContext": "teal",
        "statusLineSpend": "fgDim",
        "statusLineStaged": "green",
        "statusLineDirty": "yellow",
        "statusLineUntracked": "comment",
        "statusLineOutput": "cyan",
        "statusLineCost": "pink",
        "statusLineSubagents": "purple"
      },
      "export": {
        "pageBg": "#011627",
        "cardBg": "#022040",
        "infoBg": "#051c30"
      }
    }
  '';

  home.file.".omp/agent/theme-sources/night-owl-light.json".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/can1357/oh-my-pi/main/packages/coding-agent/src/modes/theme/theme-schema.json",
      "name": "night-owl",
      "vars": {
        "fg": "#403f53",
        "fgMuted": "#4b6479",
        "fgDim": "#536767",
        "blue": "#4876d6",
        "blueStrong": "#1b669f",
        "purple": "#994cc3",
        "purpleStrong": "#7b1fa2",
        "green": "#08916a",
        "greenStrong": "#046f50",
        "teal": "#2aa298",
        "tealStrong": "#176d67",
        "yellow": "#e0af02",
        "goldStrong": "#775f00",
        "red": "#de3d3b",
        "redStrong": "#b72b2a",
        "pink": "#d6438a",
        "pinkStrong": "#b02d71",
        "comment": "#989fb1",
        "lightGray": "#d9d9d9",
        "dimGray": "#93a1a1",
        "selectedBg": "#d3e8f8",
        "userMsgBg": "#f0f0f0",
        "toolPendingBg": "#f6f6f6",
        "toolSuccessBg": "#f0f0f0",
        "toolErrorBg": "#fff1f1",
        "customMsgBg": "#ede7f6",
        "statusBg": "#f0f0f0"
      },
      "colors": {
        "accent": "teal",
        "border": "blue",
        "borderAccent": "teal",
        "borderMuted": "lightGray",
        "success": "greenStrong",
        "error": "redStrong",
        "warning": "goldStrong",
        "muted": "fgMuted",
        "dim": "fgDim",
        "text": "fg",
        "thinkingText": "fgMuted",
        "selectedBg": "selectedBg",
        "userMessageBg": "userMsgBg",
        "userMessageText": "fg",
        "customMessageBg": "customMsgBg",
        "customMessageText": "fg",
        "customMessageLabel": "purpleStrong",
        "toolPendingBg": "toolPendingBg",
        "toolSuccessBg": "toolSuccessBg",
        "toolErrorBg": "toolErrorBg",
        "statusLineBg": "statusBg",
        "toolTitle": "fg",
        "toolOutput": "fgMuted",
        "mdHeading": "goldStrong",
        "mdLink": "blueStrong",
        "mdLinkUrl": "fgMuted",
        "mdCode": "tealStrong",
        "mdCodeBlock": "fg",
        "mdCodeBlockBorder": "fgDim",
        "mdQuote": "fgMuted",
        "mdQuoteBorder": "fgDim",
        "mdHr": "lightGray",
        "mdListBullet": "tealStrong",
        "toolDiffAdded": "greenStrong",
        "toolDiffRemoved": "redStrong",
        "toolDiffContext": "fgMuted",
        "syntaxComment": "fgDim",
        "syntaxKeyword": "purple",
        "syntaxFunction": "blueStrong",
        "syntaxVariable": "blueStrong",
        "syntaxString": "redStrong",
        "syntaxNumber": "#aa0982",
        "syntaxType": "tealStrong",
        "syntaxOperator": "tealStrong",
        "syntaxPunctuation": "fg",
        "thinkingOff": "lightGray",
        "thinkingMinimal": "fgDim",
        "thinkingLow": "blueStrong",
        "thinkingMedium": "tealStrong",
        "thinkingHigh": "purple",
        "thinkingXhigh": "purpleStrong",
        "bashMode": "greenStrong",
        "pythonMode": "goldStrong",
        "statusLineSep": "fgMuted",
        "statusLineModel": "blueStrong",
        "statusLinePath": "tealStrong",
        "statusLineGitClean": "greenStrong",
        "statusLineGitDirty": "goldStrong",
        "statusLineContext": "purpleStrong",
        "statusLineSpend": "fgMuted",
        "statusLineStaged": "goldStrong",
        "statusLineDirty": "redStrong",
        "statusLineUntracked": "fgDim",
        "statusLineOutput": "tealStrong",
        "statusLineCost": "pinkStrong",
        "statusLineSubagents": "purpleStrong"
      },
      "export": {
        "pageBg": "#f8f8ff",
        "cardBg": "#ffffff",
        "infoBg": "#eef0fa"
      }
    }
  '';

  # Startup extension: selects the current Night Owl variant and keeps OMP
  # watching the same custom theme file for both appearance modes.
  # The extension also reloads the live UI when dark-notify rewrites it.
  home.file.".omp/agent/extensions/night-owl.ts".text = ''
    import { execSync } from "node:child_process";
    import { chmodSync, copyFileSync, mkdirSync, readFileSync, watch, writeFileSync } from "node:fs";
    import { homedir } from "node:os";
    import { join } from "node:path";

    export default async function (pi: any) {
      const isDark = (() => {
        try {
          execSync("defaults read -g AppleInterfaceStyle", { stdio: "pipe" });
          return true;
        } catch {
          return false;
        }
      })();

      const themesDir = join(homedir(), ".omp/agent/themes");
      const srcDir = join(homedir(), ".omp/agent/theme-sources");
      const src = join(srcDir, isDark ? "night-owl-dark.json" : "night-owl-light.json");
      const dest = join(themesDir, "night-owl.json");

      mkdirSync(themesDir, { recursive: true });
      try {
        // Keep the watched file present while replacing its valid contents.
        copyFileSync(src, dest);
        try { chmodSync(dest, 0o644); } catch {}
      } catch {}

      let reloadTimer: ReturnType<typeof setTimeout> | undefined;
      let watcher: ReturnType<typeof watch> | undefined;
      let applyTheme: (() => Promise<void>) | undefined;

      pi.on("session_start", async (_event: any, ctx: any) => {
        if (!ctx.hasUI) return;
        applyTheme = () => ctx.ui.setTheme("night-owl").then(() => undefined);
        await applyTheme();
        try {
          watcher = watch(themesDir, (_eventType, filename) => {
            if (filename && String(filename) !== "night-owl.json") return;
            if (reloadTimer) clearTimeout(reloadTimer);
            reloadTimer = setTimeout(() => {
              reloadTimer = undefined;
              void applyTheme?.();
            }, 150);
          });
        } catch {}
      });

      pi.on("session_shutdown", () => {
        if (reloadTimer) clearTimeout(reloadTimer);
        watcher?.close();
        watcher = undefined;
        applyTheme = undefined;
      });


      // Persist the same custom theme for both automatic appearance modes.
      // Write after setTheme in case the UI API persists its own setting.
      const settingsPath = join(homedir(), ".omp/agent/settings.json");
      try {
        let settings: Record<string, unknown> = {};
        try { settings = JSON.parse(readFileSync(settingsPath, "utf8")); } catch {}
        settings.theme = { dark: "night-owl", light: "night-owl" };
        writeFileSync(settingsPath, JSON.stringify(settings, null, 4) + "\n");
      } catch {}
    }
  '';

  # Herdr official OMP integration. This reports authoritative OMP lifecycle
  # state and native session identity when OMP runs inside a Herdr pane.
  home.file.".omp/agent/extensions/herdr-omp-agent-state.ts".source =
    "${pkgs.herdr.src}/src/integration/assets/omp/herdr-agent-state.ts";

  # Omp extension that dynamically discovers models from LM Studio at startup.
  # Avoids hardcoding model IDs — just load a model in LM Studio and it appears in /model.
  home.file.".omp/agent/extensions/lmstudio.ts".text = ''
    export default async function (pi: any) {
      try {
        // LM Studio exposes an OpenAI-compatible /v1/models endpoint listing loaded models
        const response = await fetch("http://localhost:1234/v1/models");
        const { data } = await response.json();

        pi.registerProvider("lmstudio", {
          baseUrl: "http://localhost:1234/v1",
          api: "openai-completions",
          apiKey: "lm-studio", // LM Studio doesn't require a real key
          // Filter out any malformed entries before mapping
          models: data.filter((m: any) => m?.id).map((m: any) => ({
            id: m.id,
            name: m.id,
            input: ["text", "image"],
            reasoning: true,
            // Local model — no cost
            cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
            contextWindow: 64000,
            maxTokens: 16384,
          })),
        });
      } catch {
        // LM Studio is not running — skip silently so omp still starts
      }
    }
  '';
}
