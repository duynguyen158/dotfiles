{ pkgs, ... }:

let
  omp = pkgs.stdenv.mkDerivation {
    pname = "omp";
    version = "15.6.0";
    src = pkgs.fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v15.6.0/omp-darwin-arm64";
      sha256 = "1w3dqqpdz84qlfnszf2p38160c3a7j1izmy82xwghazd2k5b528i";
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
        "statusLineBg": "#01111f",
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
        "bashMode": "green",
        "pythonMode": "yellow",
        "statusLineSep": "comment",
        "statusLineModel": "blue",
        "statusLinePath": "teal",
        "statusLineGitClean": "green",
        "statusLineGitDirty": "yellow",
        "statusLineContext": "purple",
        "statusLineSpend": "comment",
        "statusLineStaged": "yellow",
        "statusLineDirty": "red",
        "statusLineUntracked": "comment",
        "statusLineOutput": "teal",
        "statusLineCost": "comment",
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
        "statusLineBg": "#e8eaf5",
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
        "bashMode": "green",
        "pythonMode": "yellow",
        "statusLineSep": "comment",
        "statusLineModel": "blue",
        "statusLinePath": "teal",
        "statusLineGitClean": "green",
        "statusLineGitDirty": "yellow",
        "statusLineContext": "purple",
        "statusLineSpend": "comment",
        "statusLineStaged": "yellow",
        "statusLineDirty": "red",
        "statusLineUntracked": "comment",
        "statusLineOutput": "teal",
        "statusLineCost": "comment",
        "statusLineSubagents": "purple"
      },
      "export": {
        "pageBg": "#f8f8ff",
        "cardBg": "#ffffff",
        "infoBg": "#eef0fa"
      }
    }
  '';

  # Startup extension: detects macOS appearance and activates the night-owl theme.
  # omp.ui.setTheme persists the choice to settings.json, enabling the file watcher
  # so dark-notify can hot-reload by overwriting ~/.omp/agent/themes/night-owl.json.
  home.file.".omp/agent/extensions/night-owl.ts".text = ''
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

      const themesDir = join(homedir(), ".omp/agent/themes");
      const srcDir = join(homedir(), ".omp/agent/theme-sources");
      const src = join(srcDir, isDark ? "night-owl-dark.json" : "night-owl-light.json");
      const dest = join(themesDir, "night-owl.json");

      try {
        try { unlinkSync(dest); } catch {}
        copyFileSync(src, dest);
        try { chmodSync(dest, 0o644); } catch {}
      } catch {}

      // pi.ui may not be ready at extension startup, so also persist directly to
      // settings.json — omp reads this on launch to select the active theme.
      const settingsPath = join(homedir(), ".omp/agent/settings.json");
      try {
        let settings: Record<string, unknown> = {};
        try { settings = JSON.parse(readFileSync(settingsPath, "utf8")); } catch {}
        settings.theme = "night-owl";
        writeFileSync(settingsPath, JSON.stringify(settings, null, 4) + "\n");
      } catch {}

      await pi.ui?.setTheme("night-owl");
    }
  '';

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
