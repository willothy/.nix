{ config, user, ... }: {

  programs.rofi = {
    enable = true;
    font = "Maple Mono NF";
    location = "center";
    terminal = user.terminal;
    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        configuration = {
          display-drun = "Applications:";
          display-window = "Windows:";
          #drun-display-format = "{name}";
          font = "JetBrainsMono Nerd Font Medium 10";
          modi = "window,run,drun";

          show-icons = true;
          hide-scrollbar = false;
          sidebar-mode = false;

          terminal = "wezterm";
          run-command = "{cmd}";
          run-shell-command = "{terminal} -e {cmd}";

          matching = "fuzzy";
          tokenize = true;

          drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
          drun-show-actions = false;
          drun-url-launcher = "xdg-open";
          drun-use-desktop-cache = false;
          drun-reload-desktop-cache = false;
          drun-parse-user = true;
          drun-parse-system = true;
        };

        "*" = {
          background = mkLiteral "#21243e66";
          background-alt = mkLiteral "#1f213966";
          background-selected = mkLiteral "#21243e66";

          foreground = mkLiteral "#cdd6f4";
          foreground-alt = mkLiteral "#a2a4ae";

          border = 0;
          margin = 0;
          padding = 0;
          spacing = 0;
        };

        window = {
          transparency = "real";
          width = mkLiteral "30%";
          background-color = mkLiteral "@background";
        };

        element = {
          enabled = true;
          padding = mkLiteral "10 px 15 px";
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@foreground-alt";
        };

        "element selected" = {
          text-color = mkLiteral "@foreground";
          background-color = mkLiteral "@background-selected";
        };

        element-text = {
          expand = true;
          background-color = mkLiteral "transparent";
          text-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };

        element-icon = {
          size = 24;
          padding = mkLiteral "0 10 0 0";
          background-color = mkLiteral "transparent";
          vertical-align = mkLiteral "0.5";
        };

        entry = {
          padding = mkLiteral "10 px";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
        };

        inputbar = {
          children = map mkLiteral [ "prompt" "entry" ];
          background-color = mkLiteral "@background";
        };

        listview = {
          background-color = mkLiteral "@background";
          columns = 1;
          lines = 10;
          dynamic = true;
          padding = mkLiteral "0 0 2 px 0";
        };

        message = {
          enabled = true;
          padding = mkLiteral "10 px 15 px";
          background-color = mkLiteral "@background";
          text-color = mkLiteral "@foreground";
          height = mkLiteral "20%";
        };

        mainbox = {
          children = map mkLiteral [ "inputbar" "message" "listview" ];
          background-color = mkLiteral "@background";
        };

        prompt = {
          enabled = true;
          padding = mkLiteral "10 0 0 15";
          background-color = mkLiteral "@background-alt";
          text-color = mkLiteral "@foreground";
        };

      };
  };
}
