# Baski Action - Build And Scan Kubernetes Images

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-header source="action.yml" -->

<!-- action-docs-description source="action.yml" -->
## Description

A composite Action for remotely building an image using
the [kubernetes-image-builder](https://github.com/kubernetes-sigs/image-builder) repo.
It uses [Baski](https://github.com/drewbernetes/baski) under the hood to build the images and scan them.

When the baski configuration changes, there will be a new release of the action to coincide, otherwise the action will remain compatible.

# Scope

⚠️Currently in beta at the moment.

# Prerequisites
* [Openstack]()./docs/openstack.md

## Update the Changelog

Get yourself a GitHub access token with permissions to read the repository, if you don't already have one.

```shell
gh auth login
gh auth token
```

Run [git cliff](https://github.com/orhun/git-cliff/)

```
export GITHUB_TOKEN=<token> # You can also add this to your ~/.bashrc or ~/.zshrc etc
git cliff -o
```
It's worth noting that `--bump` will update the changelog with what it thinks will be the next release. Make sure to check this and ensure your next tag matches this value.
The rules are:
* The default is `patch`. Generally speaking this would bea  `fix`, `docs`, `chore` etc. (see [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/))
* If `feat:` exists in the commit, then a minor version increase will happen.
* If `BREAKING CHANGE:` exists in the commit, then it will be a major version bump.
* If `--bump` is not added, it will result in an `[unreleased]` changelog entry instead of a tagged one.

Once tested and validated using your branch, get the next available tag by running the following command, and incrementing by one. e.g if this output `v0.1.31`, you should use v0.1.32.

```shell
git tag | sort -V | tail -n1
```

# TODO
* Probably loads, but this will do for now!

# License
The scripts and documentation in this project are released under the [Apache v2 License](LICENSE).
<!-- action-docs-description source="action.yml" -->

<!-- action-docs-usage source="action.yml" project="<baski-action>" version="<v0.1.0>" -->
## Usage

```yaml
- uses: <baski-action>@<v0.1.0>
  with:
    task-type:
    # Comma delimited list of Baski tasks to run. build, scan or sign are valid options - you can also use 'all' to signal all of the tasks.
    #
    # Required: false
    # Default: all

    infra-type:
    # openstack is currently supported, kubevirt is in progress
    #
    # Required: true
    # Default: openstack

    openstack-auth-url:
    # The authentication endpoint of OpenStack to send requests to.
    #
    # Required: false
    # Default: ""

    openstack-username:
    # The username to authenticate with - required if not using application credentials.
    #
    # Required: false
    # Default: ""

    openstack-password:
    # The password to authenticate with - required if not using application credentials.
    #
    # Required: false
    # Default: ""

    openstack-application-credential-id:
    # The application credential id to authenticate with - required if not using username/password combination.
    #
    # Required: false
    # Default: ""

    openstack-application-credential-secret:
    # The application credential secret to authenticate with - required if not using username/password combination.
    #
    # Required: false
    # Default: ""

    openstack-project-name:
    # The name of the Openstack project.
    #
    # Required: false
    # Default: ""

    openstack-project-id:
    # The ID of the Openstack project.
    #
    # Required: false
    # Default: ""

    openstack-user-domain-name:
    # The name of the UserDomainName.
    #
    # Required: false
    # Default: Default

    openstack-region:
    # The name of the region to deploy to.
    #
    # Required: false
    # Default: RegionOne

    openstack-identity-api-version:
    # The Identity API Version for OpenStack.
    #
    # Required: false
    # Default: 3

    openstack-interface:
    # The name of the interface.
    #
    # Required: false
    # Default: public

    openstack-network-id:
    # The ID of the network to use to use to build the scanning system.
    #
    # Required: false
    # Default: ""

    openstack-source-image-id:
    # The ID of the source image to use for the image build.
    #
    # Required: false
    # Default: ""

    openstack-flavor-name:
    # The OpenStack instance flavor to use to build the image.
    #
    # Required: false
    # Default: ""

    openstack-attach-config-drive:
    # Whether to enable to config drive in OpenStack. Useful if building an instance with an external IP attached.
    #
    # Required: false
    # Default: false

    openstack-use-floating-ip:
    # Enable to use floating IPs on the build instance.
    #
    # Required: false
    # Default: true

    openstack-floating-ip-network-name:
    # If using a floating IP configuration, add the network name here to which the floating IP will be acquired from. (Usually the provider network).
    #
    # Required: false
    # Default: Internet

    openstack-security-group:
    # The security group in OpenStack to assign to the VM that will build the image - requires SSH access.
    #
    # Required: false
    # Default: default

    openstack-image-visibility:
    # Set the image visibility once it has been created. Usually required admin permissions of sorts. Ensure you have this before setting this as the whole process will fail if permissions are not set.
    #
    # Required: false
    # Default: private

    openstack-image-disk-format:
    # The format of the image on OpenStack. Your openstack instance must support this.
    #
    # Required: false
    # Default: raw

    openstack-use-blockstorage-volume:
    # Sets the parameter block_storage_volume in the OpenStack Packer config.
    #
    # Required: false
    # Default: false

    openstack-ssh-keypair-name:
    # Use an existing SSH KeyPair from OpenStack - one will be autogenerated if not set.
    #
    # Required: false
    # Default: ""

    openstack-ssh-privatekey-file:
    # If using a ssh-keypair-name, a private key is required. In an automation environment, this is not recommended due to the potential exposure of a key.
    #
    # Required: false
    # Default: ""

    openstack-volume-type:
    # The volume type to use in OpenStack.
    #
    # Required: false
    # Default: ""

    openstack-volume-size:
    # The size of the storage volume in OpenStack.
    #
    # Required: false
    # Default: ""

    openstack-metadata-prefix:
    # Metadata-prefix will be used to prefix any metadata. This can be left blank if not required but if your metadata requires a prefix like `baski:k8s-version`, this is the place to add it.
    #
    # Required: false
    # Default: ""

    k8s-kubeconfig-path:
    # Path to the kubeconfig that will be used to generate the PVC for Kubevirt
    #
    # Required: false
    # Default: ""

    s3-endpoint:
    # The endpoint of S3.
    #
    # Required: false
    # Default: ""

    s3-access:
    # The access key used to access S3s.
    #
    # Required: false
    # Default: ""

    s3-secret:
    # The secret key used to access S3.
    #
    # Required: false
    # Default: ""

    s3-region:
    # The S3 region.
    #
    # Required: false
    # Default: us-east-1

    s3-is-ceph:
    # If the S3 endpoint is ceph based, for example behind OpenStack, this should be set to true.
    #
    # Required: false
    # Default: ""

    build-verbose:
    # Enables verbose mode.
    #
    # Required: false
    # Default: false

    build-os:
    # The OS to build. Currently supports ubuntu-2204 and ubuntu-2404.
    #
    # Required: false
    # Default: ubuntu-2204

    build-image-prefix:
    # The prefix to apply to the image name.
    #
    # Required: false
    # Default: ""

    build-image-builder-repo:
    # The to use for building Kubernetes images.
    #
    # Required: false
    # Default: https://github.com/kubernetes-sigs/image-builder.git

    build-image-builder-repo-branch:
    # The branch to use fir iamge builds.
    #
    # Required: false
    # Default: main

    build-containerd-version:
    # The containerd version to deploy into the image.
    #
    # Required: false
    # Default: 1.7.21

    build-containerd-sha256:
    # The sha256 of containerd.
    #
    # Required: false
    # Default: 3d1fcdfd0b141f4dc4916b7aee7f9a7773dc344baffc8954e1ca66b1adc5c120

    build-crictl-version:
    # The crictl version to deploy into the image.
    #
    # Required: false
    # Default: 1.30.1

    build-cni-version:
    # The CNI version to deploy into the image.
    #
    # Required: false
    # Default: 1.2.0

    build-cni-deb-version:
    # The CNI .DEB version to deploy into the image.
    #
    # Required: false
    # Default: 1.4.0-2.1

    build-k8s-version:
    # The Kubernetes version to deploy into the image.
    #
    # Required: false
    # Default: 1.30.4

    build-k8s-deb-version:
    # The Kubernetes .DEB version to deploy into the image.
    #
    # Required: false
    # Default: 1.30.4-1.1

    build-extra-debs:
    # A space-separated list of any additional (Debian / Ubuntu) packages to install.
    #
    # Required: false
    # Default: ""

    build-add-trivy:
    # Install Trivy into the image.
    #
    # Required: false
    # Default: false

    build-add-falco:
    # Install Falco into the image.
    #
    # Required: false
    # Default: false

    build-additional-images:
    # A comma delimited list of container images that should be added to the final image.
    #
    # Required: false
    # Default: ""

    build-additional-metadata:
    # A comma delimited list of metadata that should be added to the image.
    #
    # Required: false
    # Default: ""

    build-enable-gpu-support:
    # Enable the installation of GPU drivers - requires additional settings.
    #
    # Required: false
    # Default: false

    build-gpu-vendor:
    # Set the GPU vendor to install the correct drivers. AMD/NVIDIA.
    #
    # Required: false
    # Default: ""

    build-gpu-model-support:
    # The specified GPU model is added to the metadata of the image.
    #
    # Required: false
    # Default: ""

    build-gpu-instance-support:
    # The specified instance type is added to the image metadata.
    #
    # Required: false
    # Default: ""

    build-amd-driver-version:
    # The AMD driver version to install.
    #
    # Required: false
    # Default: ""

    build-amd-driver-deb-version:
    # The AMD .DEB version of the driver to install.
    #
    # Required: false
    # Default: ""

    build-amd-usecase:
    # dkms
    #
    # Required: false
    # Default: ""

    build-nvidia-driver-version:
    # The NVIDIA Driver version you are installing. This is currently only used to set the image name.
    #
    # Required: false
    # Default: ""

    build-nvidia-bucket:
    # The bucket name that the NVIDIA components are downloaded from.
    #
    # Required: false
    # Default: ""

    build-nvidia-installer-location:
    # The NVIDIA installer location in the bucket - this must be acquired from NVIDIA and uploaded to your bucket.
    #
    # Required: false
    # Default: ""

    build-nvidia-tok-location:
    # The NVIDIA .tok file location in the bucket - this must be acquired from NVIDIA and uploaded to your bucket.
    #
    # Required: false
    # Default: ""

    build-nvidia-gridd-feature-type:
    # The gridd feature type - See https://docs.nvidia.com/license-system/latest/nvidia-license-system-quick-start-guide/index.html#configuring-nls-licensed-client-on-linux for more information.
    #
    # Required: false
    # Default: 4

    scan-type:
    # Define the scan type. single or multiple
    #
    # Required: false
    # Default: single

    scan-single-image-id:
    # If scanning a single image, enter the Id of it here.
    #
    # Required: false
    # Default: ""

    scan-multiple-image-search:
    # The search prefix to locate images.
    #
    # Required: false
    # Default: kmi-

    scan-multiple-concurrency:
    # How many concurrent scans to run.
    #
    # Required: false
    # Default: 2

    scan-flavor-name:
    # The instance flavor to use to scan the image.
    #
    # Required: false
    # Default: ""

    scan-auto-delete-image:
    # Whether to delete the image should a CVE check fail.
    #
    # Required: false
    # Default: false

    scan-skip-cve-check:
    # Whether to run a CVE check after the scan runs. This will cause a pipeline to fail if a vulnerability is found and meets the threshold defined in the two options below.
    #
    # Required: false
    # Default: false

    scan-min-severity-type:
    # The type of CVE Severity to check for. NONE, LOW, MEDIUM, HIGH and CRITICAL are supported. The value entered here is the minimum it will check for along with anything higher.
    #
    # Required: false
    # Default: MEDIUM

    scan-bucket:
    # The bucket used to locate a trivyignore file.
    #
    # Required: false
    # Default: ""

    scan-trivyignore-path:
    # The path in the bucket where the trivyignore file is located.
    #
    # Required: false
    # Default: ""

    scan-trivyignore-filename:
    # The name of the trivyignore file in the bucket.
    #
    # Required: false
    # Default: trivyignore

    scan-trivyignore-list:
    # A comma delimited list of CVEs to ignore. This will be appended to the trivyignore file from the scan bucket if one is provided.
    #
    # Required: false
    # Default: ""

    sign-vault-url:
    # The endpoint address of vault from which the keys will be pulled for signing the image.
    #
    # Required: false
    # Default: ""

    sign-vault-token:
    # The token for accessing vault.
    #
    # Required: false
    # Default: ""

    sign-vault-mount-path:
    # The mount path in vault which contains the secret with the signing key.
    #
    # Required: false
    # Default: ""

    sign-vault-secret-name:
    # The name of the secret in the mount path that contains the signing key.
    #
    # Required: false
    # Default: ""

    sign-image-id:
    # The ID of the image to sign.
    #
    # Required: false
    # Default: ""
```
<!-- action-docs-usage source="action.yml" project="<baski-action>" version="<v0.1.0>" -->

<!-- action-docs-inputs source="action.yml" -->
## Inputs

| name | description | required | default |
| --- | --- | --- | --- |
| `task-type` | <p>Comma delimited list of Baski tasks to run. build, scan or sign are valid options - you can also use 'all' to signal all of the tasks.</p> | `false` | `all` |
| `infra-type` | <p>openstack is currently supported, kubevirt is in progress</p> | `true` | `openstack` |
| `openstack-auth-url` | <p>The authentication endpoint of OpenStack to send requests to.</p> | `false` | `""` |
| `openstack-username` | <p>The username to authenticate with - required if not using application credentials.</p> | `false` | `""` |
| `openstack-password` | <p>The password to authenticate with - required if not using application credentials.</p> | `false` | `""` |
| `openstack-application-credential-id` | <p>The application credential id to authenticate with - required if not using username/password combination.</p> | `false` | `""` |
| `openstack-application-credential-secret` | <p>The application credential secret to authenticate with - required if not using username/password combination.</p> | `false` | `""` |
| `openstack-project-name` | <p>The name of the Openstack project.</p> | `false` | `""` |
| `openstack-project-id` | <p>The ID of the Openstack project.</p> | `false` | `""` |
| `openstack-user-domain-name` | <p>The name of the UserDomainName.</p> | `false` | `Default` |
| `openstack-region` | <p>The name of the region to deploy to.</p> | `false` | `RegionOne` |
| `openstack-identity-api-version` | <p>The Identity API Version for OpenStack.</p> | `false` | `3` |
| `openstack-interface` | <p>The name of the interface.</p> | `false` | `public` |
| `openstack-network-id` | <p>The ID of the network to use to use to build the scanning system.</p> | `false` | `""` |
| `openstack-source-image-id` | <p>The ID of the source image to use for the image build.</p> | `false` | `""` |
| `openstack-flavor-name` | <p>The OpenStack instance flavor to use to build the image.</p> | `false` | `""` |
| `openstack-attach-config-drive` | <p>Whether to enable to config drive in OpenStack. Useful if building an instance with an external IP attached.</p> | `false` | `false` |
| `openstack-use-floating-ip` | <p>Enable to use floating IPs on the build instance.</p> | `false` | `true` |
| `openstack-floating-ip-network-name` | <p>If using a floating IP configuration, add the network name here to which the floating IP will be acquired from. (Usually the provider network).</p> | `false` | `Internet` |
| `openstack-security-group` | <p>The security group in OpenStack to assign to the VM that will build the image - requires SSH access.</p> | `false` | `default` |
| `openstack-image-visibility` | <p>Set the image visibility once it has been created. Usually required admin permissions of sorts. Ensure you have this before setting this as the whole process will fail if permissions are not set.</p> | `false` | `private` |
| `openstack-image-disk-format` | <p>The format of the image on OpenStack. Your openstack instance must support this.</p> | `false` | `raw` |
| `openstack-use-blockstorage-volume` | <p>Sets the parameter block<em>storage</em>volume in the OpenStack Packer config.</p> | `false` | `false` |
| `openstack-ssh-keypair-name` | <p>Use an existing SSH KeyPair from OpenStack - one will be autogenerated if not set.</p> | `false` | `""` |
| `openstack-ssh-privatekey-file` | <p>If using a ssh-keypair-name, a private key is required. In an automation environment, this is not recommended due to the potential exposure of a key.</p> | `false` | `""` |
| `openstack-volume-type` | <p>The volume type to use in OpenStack.</p> | `false` | `""` |
| `openstack-volume-size` | <p>The size of the storage volume in OpenStack.</p> | `false` | `""` |
| `openstack-metadata-prefix` | <p>Metadata-prefix will be used to prefix any metadata. This can be left blank if not required but if your metadata requires a prefix like <code>baski:k8s-version</code>, this is the place to add it.</p> | `false` | `""` |
| `k8s-kubeconfig-path` | <p>Path to the kubeconfig that will be used to generate the PVC for Kubevirt</p> | `false` | `""` |
| `s3-endpoint` | <p>The endpoint of S3.</p> | `false` | `""` |
| `s3-access` | <p>The access key used to access S3s.</p> | `false` | `""` |
| `s3-secret` | <p>The secret key used to access S3.</p> | `false` | `""` |
| `s3-region` | <p>The S3 region.</p> | `false` | `us-east-1` |
| `s3-is-ceph` | <p>If the S3 endpoint is ceph based, for example behind OpenStack, this should be set to true.</p> | `false` | `""` |
| `build-verbose` | <p>Enables verbose mode.</p> | `false` | `false` |
| `build-os` | <p>The OS to build. Currently supports ubuntu-2204 and ubuntu-2404.</p> | `false` | `ubuntu-2204` |
| `build-image-prefix` | <p>The prefix to apply to the image name.</p> | `false` | `""` |
| `build-image-builder-repo` | <p>The to use for building Kubernetes images.</p> | `false` | `https://github.com/kubernetes-sigs/image-builder.git` |
| `build-image-builder-repo-branch` | <p>The branch to use fir iamge builds.</p> | `false` | `main` |
| `build-containerd-version` | <p>The containerd version to deploy into the image.</p> | `false` | `1.7.21` |
| `build-containerd-sha256` | <p>The sha256 of containerd.</p> | `false` | `3d1fcdfd0b141f4dc4916b7aee7f9a7773dc344baffc8954e1ca66b1adc5c120` |
| `build-crictl-version` | <p>The crictl version to deploy into the image.</p> | `false` | `1.30.1` |
| `build-cni-version` | <p>The CNI version to deploy into the image.</p> | `false` | `1.2.0` |
| `build-cni-deb-version` | <p>The CNI .DEB version to deploy into the image.</p> | `false` | `1.4.0-2.1` |
| `build-k8s-version` | <p>The Kubernetes version to deploy into the image.</p> | `false` | `1.30.4` |
| `build-k8s-deb-version` | <p>The Kubernetes .DEB version to deploy into the image.</p> | `false` | `1.30.4-1.1` |
| `build-extra-debs` | <p>A space-separated list of any additional (Debian / Ubuntu) packages to install.</p> | `false` | `""` |
| `build-add-trivy` | <p>Install Trivy into the image.</p> | `false` | `false` |
| `build-add-falco` | <p>Install Falco into the image.</p> | `false` | `false` |
| `build-additional-images` | <p>A comma delimited list of container images that should be added to the final image.</p> | `false` | `""` |
| `build-additional-metadata` | <p>A comma delimited list of metadata that should be added to the image.</p> | `false` | `""` |
| `build-enable-gpu-support` | <p>Enable the installation of GPU drivers - requires additional settings.</p> | `false` | `false` |
| `build-gpu-vendor` | <p>Set the GPU vendor to install the correct drivers. AMD/NVIDIA.</p> | `false` | `""` |
| `build-gpu-model-support` | <p>The specified GPU model is added to the metadata of the image.</p> | `false` | `""` |
| `build-gpu-instance-support` | <p>The specified instance type is added to the image metadata.</p> | `false` | `""` |
| `build-amd-driver-version` | <p>The AMD driver version to install.</p> | `false` | `""` |
| `build-amd-driver-deb-version` | <p>The AMD .DEB version of the driver to install.</p> | `false` | `""` |
| `build-amd-usecase` | <p>dkms</p> | `false` | `""` |
| `build-nvidia-driver-version` | <p>The NVIDIA Driver version you are installing. This is currently only used to set the image name.</p> | `false` | `""` |
| `build-nvidia-bucket` | <p>The bucket name that the NVIDIA components are downloaded from.</p> | `false` | `""` |
| `build-nvidia-installer-location` | <p>The NVIDIA installer location in the bucket - this must be acquired from NVIDIA and uploaded to your bucket.</p> | `false` | `""` |
| `build-nvidia-tok-location` | <p>The NVIDIA .tok file location in the bucket - this must be acquired from NVIDIA and uploaded to your bucket.</p> | `false` | `""` |
| `build-nvidia-gridd-feature-type` | <p>The gridd feature type - See https://docs.nvidia.com/license-system/latest/nvidia-license-system-quick-start-guide/index.html#configuring-nls-licensed-client-on-linux for more information.</p> | `false` | `4` |
| `scan-type` | <p>Define the scan type. single or multiple</p> | `false` | `single` |
| `scan-single-image-id` | <p>If scanning a single image, enter the Id of it here.</p> | `false` | `""` |
| `scan-multiple-image-search` | <p>The search prefix to locate images.</p> | `false` | `kmi-` |
| `scan-multiple-concurrency` | <p>How many concurrent scans to run.</p> | `false` | `2` |
| `scan-flavor-name` | <p>The instance flavor to use to scan the image.</p> | `false` | `""` |
| `scan-auto-delete-image` | <p>Whether to delete the image should a CVE check fail.</p> | `false` | `false` |
| `scan-skip-cve-check` | <p>Whether to run a CVE check after the scan runs. This will cause a pipeline to fail if a vulnerability is found and meets the threshold defined in the two options below.</p> | `false` | `false` |
| `scan-min-severity-type` | <p>The type of CVE Severity to check for. NONE, LOW, MEDIUM, HIGH and CRITICAL are supported. The value entered here is the minimum it will check for along with anything higher.</p> | `false` | `MEDIUM` |
| `scan-bucket` | <p>The bucket used to locate a trivyignore file.</p> | `false` | `""` |
| `scan-trivyignore-path` | <p>The path in the bucket where the trivyignore file is located.</p> | `false` | `""` |
| `scan-trivyignore-filename` | <p>The name of the trivyignore file in the bucket.</p> | `false` | `trivyignore` |
| `scan-trivyignore-list` | <p>A comma delimited list of CVEs to ignore. This will be appended to the trivyignore file from the scan bucket if one is provided.</p> | `false` | `""` |
| `sign-vault-url` | <p>The endpoint address of vault from which the keys will be pulled for signing the image.</p> | `false` | `""` |
| `sign-vault-token` | <p>The token for accessing vault.</p> | `false` | `""` |
| `sign-vault-mount-path` | <p>The mount path in vault which contains the secret with the signing key.</p> | `false` | `""` |
| `sign-vault-secret-name` | <p>The name of the secret in the mount path that contains the signing key.</p> | `false` | `""` |
| `sign-image-id` | <p>The ID of the image to sign.</p> | `false` | `""` |
<!-- action-docs-inputs source="action.yml" -->

<!-- action-docs-outputs source="action.yml" -->
## Outputs

| name | description |
| --- | --- |
| `new-image-id` | <p>The image ID of the image that's been built</p> |
<!-- action-docs-outputs source="action.yml" -->