{ zap, nss }:
zap.overrideAttrs (previousAttrs: {
  buildInputs = previousAttrs.buildInputs ++ [ nss ];
  postInstall = ''
     $out/bin/zap -addoninstall network -cmd
     $out/bin/zap -certpubdump ./zap-certificate.cer -cmd
     certutil -d sql:$HOME/.pki/nssdb/ -A -t "P,," -n zap-certificate -i ./zap-certificate.cer
  '';
})
