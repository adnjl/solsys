{ ... }:
let
  iconPath = ./icons;
in
{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "loginctl kill-session $XDG_SESSION_ID";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
    ];

    style = ''
      window {
        font-family: Fira Code Medium;
        font-size: 16pt;
        color: #2B2F38;
        background-color: rgba(24, 27, 32, 0.2);
      }
      button {
        background-repeat: no-repeat;
        background-position: center;
        background-size: 20%;
        background-color: transparent;
        transition: all 0.3s ease-in;
        box-shadow: 0 0 10px 2px transparent;
        border-radius: 36px;
        margin: 1px;
      }
      button:hover {
        background-size: 30%;
        box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
        color: transparent;
        transition: all 0.2s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.3s ease-in;
      }
      #shutdown  { background-image: image(url("${iconPath}/power.png")); }
      #logout    { background-image: image(url("${iconPath}/logout.png")); }
      #reboot    { background-image: image(url("${iconPath}/restart.png")); }
      #lock      { background-image: image(url("${iconPath}/lock.png")); }
      #hibernate { background-image: image(url("${iconPath}/hibernate.png")); }
    '';
  };
}
