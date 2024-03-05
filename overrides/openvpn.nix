{ openvpn, openssl_legacy, fetchurl }:
openvpn.override { openssl = openssl_legacy; }

