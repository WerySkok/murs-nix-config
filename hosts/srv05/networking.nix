{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "8.8.8.8"
      "2001:4860:4860::8888"
      "1.1.1.1"
      "2606:4700:47008.8.8.8111"
      "4.2.2.1"
      "9.9.9.9"
      "77.88.8.8"
      "94.140.14.140"
    ];
    defaultGateway = "178.130.53.1";
    defaultGateway6 = {
      address = "";
      interface = "ens3";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          { address = "178.130.53.4"; prefixLength = 24; }
        ];
        ipv6.addresses = [
          { address = "fe80::5054:ff:fe8a:4cf7"; prefixLength = 64; }
        ];
        ipv4.routes = [{ address = "178.130.53.1"; prefixLength = 32; }];
        ipv6.routes = [{ address = ""; prefixLength = 128; }];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="52:54:00:8a:4c:f7", NAME="ens3"
    
  '';
}
