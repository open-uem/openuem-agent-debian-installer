#!/bin/bash
set -e
cwd=`pwd`

version=$1
arch=$2

if [[ $# -ne 2 ]]; then
    echo "Illegal number of parameters" >&2
    exit 2
fi

PATH=$PATH:/usr/local/go/bin

# Install packages
apt-get update -y
apt-get install dpkg-dev

# Update submodules
git submodule update --remote --recursive

# Create directory
mkdir -p ./openuem-agent_${version}_${arch}/opt/openuem-agent/bin

# Copy templates
cp -rf ./templates/DEBIAN ./openuem-agent_${version}_${arch}/
cp -rf ./templates/etc ./openuem-agent_${version}_${arch}/

# Replace version
sed -i "s/OPENUEM_VERSION/${version}/g" ./openuem-agent_${version}_${arch}/DEBIAN/postinst
sed -i "s/OPENUEM_VERSION/${version}/g" ./openuem-agent_${version}_${arch}/DEBIAN/control

# Replace arch
sed -i "s/OPENUEM_ARCH/${arch}/g" ./openuem-agent_${version}_${arch}/DEBIAN/control

# OpenUEM Agent
cd ./openuem-agent/internal/service/linux && export CGO_ENABLED=0 && export GOOS=linux && export GOARCH=${arch} && go build -o openuem-agent
cd $cwd
cp ./openuem-agent/internal/service/linux/openuem-agent ./openuem-agent_${version}_${arch}/opt/openuem-agent/bin/openuem-agent

# OpenUEM Agent Updater
cd ./openuem-agent-updater/internal/service/linux && export CGO_ENABLED=0 && export GOOS=linux && export GOARCH=${arch} && go build -o openuem-agent-updater
cd $cwd
cp ./openuem-agent-updater/internal/service/linux/openuem-agent-updater ./openuem-agent_${version}_${arch}/opt/openuem-agent/bin/openuem-agent-updater

# Generate package
dpkg-deb -Zxz --build "./openuem-agent_${version}_${arch}" ./output

