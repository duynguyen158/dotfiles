{ pkgs, ... }:

let
  omp = pkgs.stdenv.mkDerivation {
    pname = "omp";
    version = "18.4.3";
    src = pkgs.fetchurl {
      url = "https://github.com/can1357/oh-my-pi/releases/download/v18.4.3/omp-linux-arm64";
      hash = "sha256-8ADClFdR+EqHBroLr+DeQvZ8s7hoGjcD+NE5f6IsXt0=";
    };
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
    ];
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

  # Source files live outside themes/ to avoid name collision (both share "name": "night-owl").
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

  # Startup extension: selects Night Owl dark variant for headless Linux terminal
  # and keeps OMP configured with the custom theme.
  home.file.".omp/agent/extensions/night-owl.ts".text = ''
    import { chmodSync, copyFileSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
    import { homedir } from "node:os";
    import { join } from "node:path";

    export default async function (pi: any) {
      const themesDir = join(homedir(), ".omp/agent/themes");
      const srcDir = join(homedir(), ".omp/agent/theme-sources");
      const src = join(srcDir, "night-owl-dark.json");
      const dest = join(themesDir, "night-owl.json");

      mkdirSync(themesDir, { recursive: true });
      try {
        copyFileSync(src, dest);
        try { chmodSync(dest, 0o644); } catch {}
      } catch {}

      pi.on("session_start", async (_event: any, ctx: any) => {
        if (!ctx.hasUI) return;
        try {
          await ctx.ui.setTheme("night-owl");
        } catch {}
      });

      // Persist custom theme in settings.json.
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
}
