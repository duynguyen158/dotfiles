---
name: session-retrospective
description: Use when the user thanks you, says they are done/wrapping up, says to continue next session, or otherwise signals the conversation is ending. Review the current session and update AGENTS.md/skills with durable lessons when appropriate.
condition: User says thanks, wrap up, done, continue next session, ship it, good enough, or otherwise signals the session is ending.
---

# Session Retrospective / Agent Self-Improvement

When the user signals wrap-up, proactively review the current chat and decide whether durable repo-specific lessons should be captured for future agents.

Trigger phrases include, but are not limited to:

- "thanks", "thank you", "thx"
- "that's all", "we're done", "let's stop here"
- "next session", "we'll continue later"
- "wrap up", "ship it", "good enough"

## Goals

1. Preserve useful dotfiles/process learning from the session.
2. Keep future agents from rediscovering the same pitfalls.
3. Keep `AGENTS.md` concise and high-signal.
4. Keep the skill set small, well-organized, and non-overlapping.

## What to capture

Only persist lessons that are likely to recur and are actionable, such as:

- machine-specific Nix/Home Manager conventions for `air/`, `caro/`, or `spectre/`
- rebuild/stow/deployment gotchas and validation commands
- config interactions that caused surprising behavior across tmux, Ghostty, OMP/Pi, Zed, Neovim, or shell startup
- user-stated preferences for how dotfiles changes should be made or verified
- cross-file update requirements that are easy to miss, especially duplicated `air`/`caro` modules
- known-bad approaches that were tried and should not be repeated

Do **not** persist:

- one-off task details with no future value
- secrets, credentials, tokens, host-private values, or contents of `~/.secrets/`
- generic coding advice
- noisy chronological summaries
- instructions already clearly covered elsewhere
- failed experiments unless the failure changes future implementation choices

## Organization rules

Be aggressive about consolidation. Do not let the repo grow a large collection of tiny, overlapping skills.

1. Prefer updating an existing skill over creating a new one.
2. Create a new skill only when there is a distinct recurring workflow with enough substance to justify it.
3. If two skills overlap, refactor them so each has a clear responsibility.
4. Remove or merge redundant bullets when adding new ones.
5. Keep `AGENTS.md` as an index plus critical repo-wide rules, not a dumping ground.
6. Put detailed checklists in skills, not in `AGENTS.md`.
7. If a lesson affects multiple skills, add it to the most specific skill and cross-reference only if necessary.

## Update process

1. Review the current session for durable lessons.
2. Inspect `AGENTS.md` and existing `.agents/skills/*/SKILL.md` files before editing.
3. Decide one of:
   - no docs/skill update needed
   - update an existing skill
   - update `AGENTS.md` only for critical repo-wide guidance or skill routing
   - consolidate/refactor skills
   - create a new skill, only if justified
4. Make small, targeted edits.
5. Summarize what changed and why.
6. If no update was warranted, say so briefly.

## Current repo guidance patterns

- `ide-theme-change`: IDE, terminal, OMP/Pi, tmux, Neovim, Zed, and agent UI theme work.
- `session-retrospective`: end-of-session self-improvement and durable guidance capture.

If a future lesson belongs in `ide-theme-change`, update that skill rather than creating another theme-related skill.
