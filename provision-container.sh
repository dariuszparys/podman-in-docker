#!/bin/bash
# Break on the first Error
set -eu

PACKAGES=(
    apt-transport-https
    ca-certificates
    software-properties-common
    lsb-release
    curl
)

AZURECLI_PACKAGES=(
    gnupg
    azure-cli
)

PODMAN_PACKAGES=(
    podman
)

# Update apt repositories
apt-get update

# Installing Packages
DEBIAN_FRONTEND=noninteractive apt-get install -y "${PACKAGES[@]}"

# Adding software repositories:
# Microsoft Repository
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
    gpg --dearmor |
    tee /etc/apt/trusted.gpg.d/microsoft.gpg >/dev/null

AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
    tee /etc/apt/sources.list.d/azure-cli.list

# Podman Repository
. /etc/os-release
curl -L "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key" | 
    apt-key add -
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" | 
    tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

# Update apt repositories
apt-get update

# Installing Packages
DEBIAN_FRONTEND=noninteractive apt-get install -y "${AZURECLI_PACKAGES[@]}" "${PODMAN_PACKAGES[@]}"