{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      source ~/.p10k.zsh

      function mkhash() {
        if [[ -z "$1" ]]; then
          echo "Usage: mkhash <url>"
          return 1
        fi
        local hash
        hash=$(nix-prefetch-url "$1" --type sha256 --unpack)
        nix hash to-sri sha256:"$hash"
      }
    '';

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
  };
}
