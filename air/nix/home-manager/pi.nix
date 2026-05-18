{ pkgs, llm-agents, ... }:

{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
  ];

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
