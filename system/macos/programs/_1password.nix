{ config, pkgs, lib, ... }:

let

  cfg = config.programs._1password;

in
{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "_1password" "gid" ] ''
      A preallocated GID will be used instead.
    '')
  ];

  options = {
    programs._1password = {
      enable = lib.mkEnableOption "the 1Password CLI tool";

      package = lib.mkPackageOption pkgs "1Password CLI" {
        default = [ "_1password" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword-cli.gid = config.ids.gids.onepassword-cli;
  };
}
