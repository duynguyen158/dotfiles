{ pkgs, llm-agents, ... }:

{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
  ];

  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers = {
      lmstudio = {
        baseUrl = "http://localhost:1234/v1";
        api = "openai-completions";
        apiKey = "lm-studio";
        models = [
          {
            id = "google/gemma-4-e4b";
            input = [
              "text"
              "image"
            ];
            contextWindow = 128000;
            maxTokens = 16384;
          }
        ];
      };
    };
  };
}
