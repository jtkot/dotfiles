{
  pkgs,
  inputs,
  ...
}:
{
  security.sudo.extraConfig = "Defaults pwfeedback";
  time.timeZone = "Europe/Warsaw";
  environment.shellAliases = {
    rm = "rm -i";
    cp = "cp -i";
    mv = "mv -i";
    sudo = "sudo ";
  };
}
