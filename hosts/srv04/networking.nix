{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "31.184.213.203"
                    "46.8.251.36" ];
    defaultGateway = "109.248.206.1";
    defaultGateway6 = {
      address = "";
      interface = "ens3";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          { address="109.248.206.92"; prefixLength=24; }
        ];
        ipv6.addresses = [
          { address="fe80::5054:ff:fefb:ff62"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "109.248.206.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = ""; prefixLength = 128; } ];
      };
      
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="52:54:00:fb:ff:62", NAME="ens3"
    
  '';
}
