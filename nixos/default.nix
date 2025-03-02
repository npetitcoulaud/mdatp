{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mdatp;
in
{
  options.services.mdatp = {
    enable = lib.mkEnableOption "mdatp";
    package = lib.mkPackageOption pkgs "mdatp" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    users.users.mdatp = {
      group = "mdatp";
      isSystemUser = true;
    };
    users.groups.mdatp = { };
  };
}
