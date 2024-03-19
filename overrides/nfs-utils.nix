{ lib, nfs-utils, fetchurl, systemd, util-linux, coreutils, libkrb5, buildPackages }:
let
  version = "2.5.1";
  statdPath = lib.makeBinPath [ systemd util-linux coreutils ];
in
nfs-utils.overrideAttrs (old: {
  inherit version;

  src = fetchurl {
    url = "mirror://kernel/linux/utils/nfs-utils/${version}/${old.pname}-${version}.tar.xz";
    hash = "sha256-DxyBcOFqB9mDa78INtSNDIQrbw4Oixh0jwmXUYUdMMQ=";
  };

  configureFlags = [
    "--enable-gss"
    "--enable-svcgss"
    "--with-statedir=/var/lib/nfs"
    "--with-krb5=${lib.getLib libkrb5}"
    "--with-systemd=${placeholder "out"}/etc/systemd/system"
    "--enable-libmount-mount"
    "--with-pluginpath=${placeholder "lib"}/lib/libnfsidmap" # this installs libnfsidmap
    "--with-rpcgen=${buildPackages.rpcsvc-proto}/bin/rpcgen"
  ];

  postPatch =
    ''
      patchShebangs tests
      sed -i "s,/usr/sbin,$out/bin,g" utils/statd/statd.c
      sed -i "s,^PATH=.*,PATH=$out/bin:${statdPath}," utils/statd/start-statd

      configureFlags="--with-start-statd=$out/bin/start-statd $configureFlags"

      substituteInPlace systemd/nfs-utils.service \
        --replace "/bin/true" "${coreutils}/bin/true"

      substituteInPlace utils/mount/Makefile.in \
        --replace "chmod 4511" "chmod 0511"

      sed '1i#include <stdint.h>' -i support/nsm/rpc.c
    '';

})
