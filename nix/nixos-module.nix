self: { config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.pp-to-epp;
in {
  options.services.pp-to-epp = {
    enable = mkEnableOption "pp-to-epp";
    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.default;
      description = mdDoc ''
        Package to use for pp-to-epp service.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.pp-to-epp = {
      description = "Power Profiles Daemon to AMD & Intel PSTATE EPP";
      wantedBy = [ "multi-user.target" ];
      requires = [ "power-profiles-daemon.service" ];
      after = [ "power-profiles-daemon.service" ];
      serviceConfig = {
        Type = "simple";
        Restart = "on-failure";
        User = "root";
        ExecStart = "${lib.getExe cfg.package}";
      };
    };
  };


} 
