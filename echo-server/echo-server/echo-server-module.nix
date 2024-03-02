{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.echo-server;
in {
  options.services.echo-server = {
    enable = lib.mkEnableOption "echo-server";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8123;
      description = "Port to listen on";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.echo-server = {
      description = "TCP Echo Server Daemon";
      serviceConfig = {
        ExecStart = "${pkgs.echo-server}/bin/echo-server --port=${builtins.toString cfg.port}";
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
