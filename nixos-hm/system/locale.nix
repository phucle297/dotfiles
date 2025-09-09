{ config, pkgs, ... }:
{
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-configtool
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-unikey
      ];
    };
  };
}
