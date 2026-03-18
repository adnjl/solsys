{
  pkgs,
  username,
  ...
}:
{
  users.knownUsers = [ username ];
  users.users.${username} = {
    description = username;
    uid = 501;
    home = "/Users/${username}";
    ignoreShellProgramCheck = true;
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  nix.settings = {
    trusted-users = [ username ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
