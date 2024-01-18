#!/usr/bin/env bash

nix-shell -p nix-prefetch --run "nix-prefetch '{ sha256 }: (callPackage (import ./wings.nix) { }).go-modules.overrideAttrs (_: { modSha256 = sha256; })'"