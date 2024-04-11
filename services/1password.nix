{
  pkgs,
  lib,
  ...
}:
{
  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [
      "willothy"
    ];
  };
  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        brave
      '';
      mode = "0755";
    };
  };
  systemd.user.services."1password-daemon" = {
    description = "1password-daemon";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs._1password-gui}/bin/1password --silent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
  };
}
