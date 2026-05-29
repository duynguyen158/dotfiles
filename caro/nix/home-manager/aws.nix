{ lib, pkgs, ... }:

{
  # Generates ~/.aws/config at nixup time from vars in ~/.secrets:
  #   export CONF_AWS_SSO_URL="..."
  #   export CONF_AWS_SSO_SESSION="..."
  #   export CONF_AWS_ACCOUNT_ID="..."
  #   export CONF_AWS_ACCOUNT_NAME="..."
  #   export CONF_AWS_ROLE_NAME="..."
  #   export CONF_AWS_REGION="..."
  home.packages = [ pkgs.awscli2 ];

  home.activation.awsConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "$HOME/.secrets/aws" ]; then
      . "$HOME/.secrets/aws"
      mkdir -p "$HOME/.aws"
      cat > "$HOME/.aws/config" << EOF
[sso-session $CONF_AWS_SSO_SESSION]
sso_start_url = $CONF_AWS_SSO_URL
sso_region = $CONF_AWS_REGION
sso_registration_scopes = sso:account:access

[profile $CONF_AWS_ACCOUNT_NAME]
sso_session = $CONF_AWS_SSO_SESSION
sso_account_id = $CONF_AWS_ACCOUNT_ID
sso_role_name = $CONF_AWS_ROLE_NAME
region = $CONF_AWS_REGION
output = json
EOF
    fi
  '';
}
