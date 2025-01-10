#!/usr/bin/env bash

function update(){
  mkdir -p "${HOME}/bin"
  # Pulls latest version by default
  BASKI_VERSION=$(curl -sL https://api.github.com/repos/drewbernetes/baski/releases | jq -r ".[0].name")
  curl -LO https://github.com/drewbernetes/baski/releases/download/${BASKI_VERSION}/baski-linux-amd64
  mv baski-linux-amd64 "${HOME}/bin/baski"
  chmod +x "${HOME}/bin/baski"
  export PATH="${PATH}:${HOME}/bin"
  exit 0
}

function generate_infra_config(){
  cat <<-EOF > /tmp/baski.yaml
  infra:
    type: ${INFRA_TYPE}
EOF
}

function generate_openstack_core_config(){
    cat <<-EOF >> /tmp/baski.yaml
    openstack:
      clouds-file: "${HOME}/.config/openstack"
      cloud-name: openstack
EOF
}

function generate_openstack_base_config(){
    cat <<-EOF >> /tmp/baski.yaml
      network-id: "${OS_NET_ID}"
      attach-config-drive: ${OS_CONF_DRIVE}
      floating-ip-network-name: "${OS_FIP_NET}"
      security-group: "${OS_SECURITY_GROUP}"
      flavor-name: "${OS_FLAVOR}"
EOF
}

function generate_s3_credentials_config(){
    cat <<-EOF >> /tmp/baski.yaml
  s3:
    endpoint: "${S3_ENDPOINT}"
    access-key: "${S3_ACCESS}"
    secret-key: "${S3_SECRET}"
    region: "${S3_REGION}"
    is-ceph: ${S3_IS_CEPH}
EOF
}

function generate_build_config(){
  generate_infra_config
  generate_openstack_core_config
  generate_openstack_base_config

  if [[ ${INFRA_TYPE} == "openstack" ]]; then
    cat <<-EOF >> /tmp/baski.yaml
      source-image: "${OS_SOURCE_IMAGE}"
      use-floating-ip: "${OS_USE_FIP}"
      image-visibility: "${OS_VISIBILITY}"
      image-disk-format: "${OS_DISK_FORMAT}"
      volume-type: "${OS_VOL_TYPE}"
      volume-size: "${OS_VOL_SIZE}"
      use-blockstorage-volume: "${OS_USE_BLOCK}"
      metadata-prefix: "${OS_META_PREFIX}"
EOF
  fi

  generate_s3_credentials_config

  cat <<-EOF >> /tmp/baski.yaml
  build:
    verbose: "${BUILD_VERBOSE}"
    build-os: "${BUILD_OS}"
    image-prefix: "${BUILD_PREFIX}"
    image-repo: "${BUILD_REPO}"
    image-repo-branch: "${BUILD_REPO_BRANCH}"
    containerd-version: "${BUILD_CONTAINERD_VERS}"
    containerd-sha256: "${BUILD_CONTAINERD_SHA256}"
    crictl-version: "${BUILD_CRI_VERS}"
    cni-version: "${BUILD_CNI_VERS}"
    cni-deb-version: "${BUILD_CNI_DEB_VERS}"
    kubernetes-version: "${BUILD_K8S_VERS}"
    kubernetes-deb-version: "${BUILD_K8S_DEB_VERS}"
    extra-debs: "${BUILD_EXTRA_DEBS}"
    add-trivy: ${BUILD_TRIVY}
    add-falco: ${BUILD_FALCO}
  gpu:
    enable-gpu-support: ${GPU_ENABLE}
    gpu-vendor: ${GPU_VENDOR}
    gpu-model-support: ${GPU_MODEL}
    gpu-instance-support: ${GPU_INSTANCE}
    amd-driver-version: "${GPU_AMD_DRIVER_VERS}"
    amd-deb-version: "${GPU_AMD_DRIVER_DEB_VERS}"
    amd-usecase: "${GPU_AMD_USECASE}"
    nvidia-driver-version: "${GPU_NVIDIA_DRIVER_VERS}"
    nvidia-bucket: "${GPU_NVIDIA_BUCKET}"
    nvidia-installer-location: "${GPU_NVIDIA_INSTALLER}"
    nvidia-tok-location: "${GPU_NVIDIA_TOK}"
    nvidia-gridd-feature-type: ${GPU_NVIDIA_GRIDD}
EOF

# Parse additional images and additional metadata
  if [[ "${BUILD_ADDITIONAL_IMAGES}" != "" ]]; then
    images=$(echo "${BUILD_ADDITIONAL_IMAGES}" | tr ',' '\n' | sed 's/^/  - /')
    images=$(echo -e "  additional-images:\n$images")
  else
    images=""
  fi
  if [[ "${BUILD_ADDITIONAL_META}" != "" ]]; then
    metas=$(echo "${BUILD_ADDITIONAL_META}" | tr ',' '\n' | sed 's/^/    /')
    metas=$(echo -e "  additional-metadata:\n$metas")
  else
    metas=""
  fi

  cat <<-EOF >> /tmp/baski.yaml
  ${images}
  ${metas}
EOF
}

function build(){
  "${HOME}/bin/baski" build

  if [ $? -ne 0 ]; then
    exit 1
  fi

  echo "new-image-id=$(cat /tmp/imgid.out)" >> $GITHUB_OUTPUT
  exit 0
}

function generate_scan_config() {
  generate_infra_config
  generate_openstack_core_config
  generate_openstack_base_config
  generate_s3_credentials_config

  if [[ "${SCAN_TRIVY_LIST}" != "" ]]; then
    cvelist=$(echo "${SCAN_TRIVY_LIST}" | tr ',' '\n' | sed 's/^/    - /')
    cvelist=$(echo -e "  trivyignore-list:\n$cvelist")
  else
    cvelist=""
  fi

  if [[ ${SCAN_TYPE} == "single" ]]; then
  cat <<-EOF >> /tmp/baski.yaml
  scan:
    single:
      image-id: "${SCAN_SINGLE_IMG_ID}"
EOF
  else
  cat <<-EOF >> /tmp/baski.yaml
  scan
    multiple:
      image-search: "${SCAN_MULTI_PREFIX}"
      concurrency: ${SCAN_MULTI_CONCURRENCY}
EOF
  fi

  FLV=${OS_FLAVOR}
  if [[ -z $SCAN_FLAVOR ]]; then
    FLV=${SCAN_FLAVOR}
  fi

  cat <<-EOF >> /tmp/baski.yaml
    flavor-name: "${FLV}"
    auto-delete-image: ${SCAN_AUTO_DELETE}
    skip-cve-check: ${SCAN_SKIP_CVE}
    max-severity-type: ${SCAN_SEV}
    scan-bucket: "${SCAN_BUCKET}"
    trivyignore-path: "${SCAN_TRIVY_PATH}"
    trivyignore-filename: "${SCAN_TRIVY_FILE}"
    trivyignore-list:
  ${cvelist}
EOF
}

function scan(){
  "${HOME}/bin/baski" scan

  if [ $? -ne 0 ]; then
    exit 1
  fi

  exit 0
}

function generate_sign_config(){

  generate_infra_config
  generate_openstack_core_config

  cat <<-EOF >> /tmp/baski.yaml
  sign:
    vault:
      url: "${SIGN_VAULT_URL}"
      token: "${SIGN_VAULT_TOKEN}"
      mount-path: "${SIGN_VAULT_MOUNT}"
      secret-name: "${SIGN_VAULT_SECRET}"
    image-id: "${SIGN_IMG_ID}"
EOF
}

function sign(){
  "${HOME}/bin/baski" sign image

  if [ $? -ne 0 ]; then
    exit 1
  fi

  exit 0
}

cmd=$1

case $cmd in
  update)
    update
    shift
    ;;
  build)
    generate_build_config
    build
    shift
    ;;
  scan)
    generate_scan_config
    scan
    shift
    ;;
  sign)
    generate_sign_config
    sign
    shift
    ;;
esac
