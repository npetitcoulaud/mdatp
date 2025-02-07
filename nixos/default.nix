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
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mdatp ];
    systemd.packages = [ pkgs.mdatp ];
    users.users.mdatp = {
      group = "mdatp";
      isSystemUser = true;
    };
    users.groups.mdatp = { };
  };
}
