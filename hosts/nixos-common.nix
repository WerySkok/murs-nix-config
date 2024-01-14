{ abs, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";

  console = {
    font = "cyr-sun16";
    keyMap = "ruwin_alt_sh-UTF-8";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  security.sudo.wheelNeedsPassword = false;

  age.identityPaths = [
    "/etc/ssh/agenix_key"
  ];

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    git
    micro
    wget
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  system.stateVersion = "23.11";
}
