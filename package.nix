{
  stdenv,
  libcap,
  acl,
  zlib,
  pcre,
  sqlite,
  elfutils,
  lib,
  fetchurl,
  dpkg,
  ...
}:
stdenv.mkDerivation rec {
  pname = "mdatp";
  version = "101.24112.0003";

  src = fetchurl {
    url = "https://packages.microsoft.com/debian/12/prod/pool/main/m/${pname}/${pname}_${version}_amd64.deb";
    hash = "sha256-awXbrG3vDcDs00yqli3Hkr9LperkbNMEACZZFcN4Pfk=";
  };

  nativeBuildInputs = [ dpkg ];

  buildPhase =
    let
      libPath = {
        mdatp = lib.makeLibraryPath [
          libcap
          acl
          zlib
          pcre
          sqlite
          elfutils
        ];
      };
    in
    ''
      runHook preBuild

      ls -d opt/microsoft/mdatp/lib/* | xargs patchelf \
        --set-rpath $out/opt/microsoft/mdatp/lib:${libPath.mdatp}

      ls -d opt/microsoft/mdatp/sbin/*.so | xargs patchelf \
        --set-rpath $out/opt/microsoft/mdatp/lib:${libPath.mdatp}

      ls -d opt/microsoft/mdatp/sbin/* | grep -v '\.so' | xargs patchelf \
        --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        --set-rpath $out/opt/microsoft/mdatp/lib:${libPath.mdatp}

      #patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/opt/microsoft/mdatp/lib:${libPath.mdatp} opt/microsoft/mdatp/sbin/wdavdaemon

      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv opt $out/

    runHook postInstall
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "Microsoft Defender for Endpoint";
    homepage = "https://www.microsoft.com/en-us/microsoft-365/security/endpoint";
    # license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ npetitcoulaud ];
  };
}
