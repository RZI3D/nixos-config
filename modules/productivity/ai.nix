{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    environmentVariables = {
      OLLAMA_NUM_THREADS = "8"; # i5 10th gen 4c/8t
    };
    loadModels = [
      "phi4:14b"
      "qwen2.5-coder:7b-instruct-q4_K_M"
      "deepseek-r1:7b"
      "mxbai-embed-large:335m"
    ];
  };
}
