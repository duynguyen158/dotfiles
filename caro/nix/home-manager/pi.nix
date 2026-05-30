{ pkgs, llm-agents, ... }:

{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
  ];

  programs.zsh.initContent = ''
    pi() {
      (
        if [[ -f "$HOME/.secrets/ai_providers" ]]; then
          set -a; source "$HOME/.secrets/ai_providers"; set +a
        else
          echo "💡 Create ~/.secrets/ai_providers with your API keys (e.g. OPENAI_API_KEY=sk-...) to have them automatically available to pi."
        fi
        command pi "$@"
      )
    }
  '';

  # Source files live outside themes/ to avoid name collision (all three share "name": "night-owl").
  # The extension copies the right one to themes/night-owl.json at startup.
  home.file.".pi/agent/theme-sources/night-owl-dark.json".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
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
        "customMsgBg": "#1a1130"
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
        "bashMode": "green"
      },
      "export": {
        "pageBg": "#011627",
        "cardBg": "#022040",
        "infoBg": "#051c30"
      }
    }
  '';

  home.file.".pi/agent/theme-sources/night-owl-light.json".text = ''
    {
      "$schema": "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json",
      "name": "night-owl",
      "vars": {
        "blue": "#4876d6",
        "purple": "#994cc3",
        "green": "#08916a",
        "teal": "#2aa298",
        "yellow": "#e0af02",
        "red": "#de3d3b",
        "comment": "#989fb1",
        "lightGray": "#d9d9d9",
        "dimGray": "#93a1a1",
        "selectedBg": "#d3e8f8",
        "userMsgBg": "#f0f0f0",
        "toolPendingBg": "#f6f6f6",
        "toolSuccessBg": "#f0f0f0",
        "toolErrorBg": "#fff1f1",
        "customMsgBg": "#ede7f6"
      },
      "colors": {
        "accent": "teal",
        "border": "blue",
        "borderAccent": "teal",
        "borderMuted": "lightGray",
        "success": "green",
        "error": "red",
        "warning": "yellow",
        "muted": "dimGray",
        "dim": "comment",
        "text": "#403f53",
        "thinkingText": "dimGray",
        "selectedBg": "selectedBg",
        "userMessageBg": "userMsgBg",
        "userMessageText": "#403f53",
        "customMessageBg": "customMsgBg",
        "customMessageText": "#403f53",
        "customMessageLabel": "purple",
        "toolPendingBg": "toolPendingBg",
        "toolSuccessBg": "toolSuccessBg",
        "toolErrorBg": "toolErrorBg",
        "toolTitle": "#403f53",
        "toolOutput": "dimGray",
        "mdHeading": "yellow",
        "mdLink": "blue",
        "mdLinkUrl": "comment",
        "mdCode": "teal",
        "mdCodeBlock": "green",
        "mdCodeBlockBorder": "dimGray",
        "mdQuote": "dimGray",
        "mdQuoteBorder": "dimGray",
        "mdHr": "lightGray",
        "mdListBullet": "teal",
        "toolDiffAdded": "green",
        "toolDiffRemoved": "red",
        "toolDiffContext": "dimGray",
        "syntaxComment": "#989fb1",
        "syntaxKeyword": "#994cc3",
        "syntaxFunction": "#4876d6",
        "syntaxVariable": "blue",
        "syntaxString": "#c96765",
        "syntaxNumber": "#aa0982",
        "syntaxType": "#0c969b",
        "syntaxOperator": "#0c969b",
        "syntaxPunctuation": "#403f53",
        "thinkingOff": "lightGray",
        "thinkingMinimal": "comment",
        "thinkingLow": "blue",
        "thinkingMedium": "teal",
        "thinkingHigh": "purple",
        "thinkingXhigh": "#7b1fa2",
        "bashMode": "green"
      },
      "export": {
        "pageBg": "#f8f8ff",
        "cardBg": "#ffffff",
        "infoBg": "#eef0fa"
      }
    }
  '';

  # Startup extension: detects macOS appearance and activates the night-owl theme.
  # pi.ui.setTheme persists the choice to settings.json, enabling the file watcher
  # so dark-notify can hot-reload by overwriting ~/.pi/agent/themes/night-owl.json.
  home.file.".pi/agent/extensions/night-owl.ts".text = ''
    import { execSync } from "node:child_process";
    import { chmodSync, copyFileSync, mkdirSync, readFileSync, unlinkSync, writeFileSync } from "node:fs";
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

      const themesDir = join(homedir(), ".pi/agent/themes");
      const srcDir = join(homedir(), ".pi/agent/theme-sources");
      const src = join(srcDir, isDark ? "night-owl-dark.json" : "night-owl-light.json");
      const dest = join(themesDir, "night-owl.json");

      mkdirSync(themesDir, { recursive: true });
      try {
        try { unlinkSync(dest); } catch {}
        copyFileSync(src, dest);
        try { chmodSync(dest, 0o644); } catch {}
      } catch {}

      // pi.ui may not be ready at extension startup, so also persist directly to
      // settings.json — pi reads this on launch to select the active theme.
      const settingsPath = join(homedir(), ".pi/agent/settings.json");
      try {
        let settings: Record<string, unknown> = {};
        try { settings = JSON.parse(readFileSync(settingsPath, "utf8")); } catch {}
        settings.theme = "night-owl";
        writeFileSync(settingsPath, JSON.stringify(settings, null, 4) + "\n");
      } catch {}

      await pi.ui?.setTheme("night-owl");
    }
  '';

  # Pi extension that dynamically discovers models from LM Studio at startup.
  # Avoids hardcoding model IDs — just load a model in LM Studio and it appears in /model.
  home.file.".pi/agent/extensions/lmstudio.ts".text = ''
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
        // LM Studio is not running — skip silently so pi still starts
      }
    }
  '';
}
