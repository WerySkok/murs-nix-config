# Copied from https://github.com/BadCoder-Network/pterodactyl-wings-nix
{ lib
, buildGo126Module
, fetchFromGitHub
,
}:
buildGo126Module rec {
  pname = "pterodactyl-wings";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-12nV7jFlVbjjZT3uFbYEhTyJcZe88FEQEguBkgcbHGI=";
  };

  vendorHash = "sha256-BtATik0egFk73SNhawbGnbuzjoZioGFWeA4gZOaofTI=";
  subPackages = ["."];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];

  meta = with lib; {
    description = "The server control plane for Pterodactyl Panel. Written from the ground-up with security, speed, and stability in mind";
    homepage = "https://github.com/pterodactyl/wings";
    license = licenses.mit;
    mainProgram = "wings";
    changelog = "https://github.com/pterodactyl/wings/releases/tag/v${version}";
    platforms = platforms.linux;
  };
}
