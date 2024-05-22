# Copied from https://github.com/BadCoder-Network/pterodactyl-wings-nix
{ lib
, buildGo122Module
, fetchFromGitHub
,
}:
buildGo122Module rec {
  pname = "pterodactyl-wings";
  version = "v1.11.13";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "${version}";
    sha256 = "sha256-UpYUHWM2J8nH+srdKSpFQEaPx2Rj2+YdphV8jJXcoBU=";
  };

  vendorHash = "sha256-eWfQE9cQ7zIkITWwnVu9Sf9vVFjkQih/ZW77d6p/Iw0=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}
