# Copied from https://github.com/BadCoder-Network/pterodactyl-wings-nix
{ lib
, buildGo120Module
, fetchFromGitHub
,
}:
buildGo120Module rec {
  pname = "pterodactyl-wings";
  version = "v1.11.8";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "${version}";
    sha256 = "sha256-JzbxROashDAL4NSeqMcWR9PgFqe9peBNpeofA347oE4=";
  };

  vendorHash = "sha256-fn+U91jX/rmL/gdMwRAIDEj/m0Zqgy81BUyv4El7Qxw=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}
