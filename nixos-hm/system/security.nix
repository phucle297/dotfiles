{ config, pkgs, ... }:
{
  # security.pki.certificates = [
  #   ''
  #     -----BEGIN CERTIFICATE-----
  #     -----END CERTIFICATE-----
  #   ''
  # ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "permees" ];
  };

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        zen
      '';
      mode = "0755";
    };
  };
}
