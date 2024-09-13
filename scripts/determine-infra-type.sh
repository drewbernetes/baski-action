#!/bin/bash

# Uncomment this and comment the next on out to test locally.
#OS_CLOUDS_DIR="/tmp/"
OS_CLOUDS_DIR="${HOME}/.config/openstack"
OS_CLOUDS_FILE="${OS_CLOUDS_DIR}/clouds.yaml"

# Creates the clouds.yaml file based on whether a username or application credential is being used.
function create_clouds_yaml(){

cat <<-EOF > "${OS_CLOUDS_FILE}"
clouds:
  openstack:
    region_name: "${OS_REGION}"
    interface: "${OS_INTERFACE}"
    identity_api_version: ${OS_API}
    auth:
      auth_url: "${OS_URL}"
      project_name: "${OS_PROJ_NAME}"
      project_id: "${OS_PROJ_ID}"
EOF

if [[ -z $OS_APP_ID ]] || [[ -z $OS_APP_SECRET ]]; then
  cat <<-EOF >> "${OS_CLOUDS_FILE}"
      username: "${OS_USER}"
      password: "${OS_PASSWD}"
      user_domain_name: "${OS_USR_DOM}"
EOF
else
  cat <<-EOF >> "${OS_CLOUDS_FILE}"
      application_credential_id: "${OS_APP_ID}"
      application_credential_secret: "${OS_APP_SECRET}"
      project_domain_name: "Default"
    auth_type: "v3applicationcredential"
EOF
fi
}

# Create a directory to store the clouds.yaml file and then calls the function to create the file.
function setup_openstack() {
  # If infra type is set and is openstack, create a clouds.yaml file.
  mkdir -p "${OS_CLOUDS_DIR}"
  create_clouds_yaml
}

if [[ ${INFRA_TYPE} == "openstack" ]]; then
  setup_openstack
fi
