{ pkgs
, inputs
, ...
}: {
  imports = [
    ./docker.nix
    inputs.arion.nixosModules.arion
  ];
  virtualisation.arion.backend = "docker";
}
