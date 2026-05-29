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
        "blue": "#82aaff",
        "purple": "#c792ea",
        "green": "#addb67",
        "teal": "#7fdbca",
        "yellow": "#ffcb8b",
        "red": "#ef5350",
        "comment": "#637777",
        "border": "#5f7e97",
        "dim": "#4a5568",
        "selectedBg": "#0a2a4a",
        "userMsgBg": "#022040",
        "toolPendingBg": "#051826",
        "toolSuccessBg": "#031a12",
        "toolErrorBg": "#1c0303",
        "customMsgBg": "#1a0a2e"
      },
      "colors": {
        "accent": "teal",
        "border": "blue",
        "borderAccent": "teal",
        "borderMuted": "border",
        "success": "green",
        "error": "red",
        "warning": "yellow",
        "muted": "border",
        "dim": "dim",
        "text": "#d6deeb",
        "thinkingText": "border",
        "selectedBg": "selectedBg",
        "userMessageBg": "userMsgBg",
        "userMessageText": "#d6deeb",
        "customMessageBg": "customMsgBg",
        "customMessageText": "#d6deeb",
        "customMessageLabel": "purple",
        "toolPendingBg": "toolPendingBg",
        "toolSuccessBg": "toolSuccessBg",
        "toolErrorBg": "toolErrorBg",
        "toolTitle": "#d6deeb",
        "toolOutput": "border",
        "mdHeading": "yellow",
        "mdLink": "blue",
        "mdLinkUrl": "comment",
        "mdCode": "teal",
        "mdCodeBlock": "green",
        "mdCodeBlockBorder": "border",
        "mdQuote": "border",
        "mdQuoteBorder": "border",
        "mdHr": "dim",
        "mdListBullet": "teal",
        "toolDiffAdded": "green",
        "toolDiffRemoved": "red",
        "toolDiffContext": "border",
        "syntaxComment": "#637777",
        "syntaxKeyword": "#c792ea",
        "syntaxFunction": "#82aaff",
        "syntaxVariable": "#d6deeb",
        "syntaxString": "#ecc48d",
        "syntaxNumber": "#f78c6c",
        "syntaxType": "#7fdbca",
        "syntaxOperator": "#89ddff",
        "syntaxPunctuation": "#d6deeb",
        "thinkingOff": "dim",
        "thinkingMinimal": "border",
        "thinkingLow": "blue",
        "thinkingMedium": "teal",
        "thinkingHigh": "purple",
        "thinkingXhigh": "#d183e8",
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
        "green": "#4e9b47",
        "teal": "#08916a",
        "yellow": "#e0af02",
        "red": "#d3423e",
        "comment": "#989fb1",
        "lightGray": "#c5c8d8",
        "dimGray": "#8d8fa8",
        "selectedBg": "#d0d5e8",
        "userMsgBg": "#f0f2fa",
        "toolPendingBg": "#e8ecf8",
        "toolSuccessBg": "#e8f5e9",
        "toolErrorBg": "#fce8e8",
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
        "syntaxVariable": "#403f53",
        "syntaxString": "#c96765",
        "syntaxNumber": "#aa5d00",
        "syntaxType": "#08916a",
        "syntaxOperator": "#403f53",
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
    import { chmodSync, copyFileSync, readFileSync, unlinkSync, writeFileSync } from "node:fs";
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
