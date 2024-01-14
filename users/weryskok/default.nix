{ abs, pkgs, inputs, ... }:

{
  users.users.weryskok = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "docker" ];
    shell = pkgs.zsh;

    openssh.authorizedKeys.keyFiles = [
      (abs "ssh/weryskok.pub")
    ];
  };

  home-manager.users.weryskok = { pkgs, ... }: {
    imports = [
      inputs.vscode-server.homeModules.default
      ./zsh.nix
    ];

    services.vscode-server.enable = true;
    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      tree
      nixpkgs-fmt
      htop
      jq
      inputs.nil.packages.${system}.default
      inputs.agenix.packages.${system}.default
    ];
  };
}
