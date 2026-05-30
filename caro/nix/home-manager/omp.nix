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

      const themesDir = join(homedir(), ".omp/agent/themes");
      const srcDir = join(homedir(), ".omp/agent/theme-sources");
      const src = join(srcDir, isDark ? "night-owl-dark.json" : "night-owl-light.json");
      const dest = join(themesDir, "night-owl.json");

      mkdirSync(themesDir, { recursive: true });
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
