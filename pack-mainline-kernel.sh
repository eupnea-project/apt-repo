#!/bin/bash
# This script will pack the mainline kernel into 3 debian packages
set -e

# create dirs
mkdir -p eupnea-mainline-kernel/DEBIAN
mkdir -p eupnea-mainline-kernel-modules/DEBIAN
mkdir -p eupnea-mainline-kernel-headers/DEBIAN

mkdir -p eupnea-mainline-kernel/tmp/eupnea-kernel-update
mkdir -p eupnea-mainline-kernel-modules/lib/modules
mkdir -p eupnea-mainline-kernel-headers/usr/src

# Download kernel files
#curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/bzImage -o bzImage
#curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/headers.tar.xz  -o headers.tar.xz
#curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/latest/download/modules.tar.xz -o modules.tar.xz
curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/download/dev-build/bzImage -o bzImage
curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/download/dev-build/headers.tar.xz -o headers.tar.xz
curl --silent -L https://github.com/eupnea-linux/mainline-kernel/releases/download/dev-build/modules.tar.xz -o modules.tar.xz

# copy kernel image to package
cp bzImage eupnea-mainline-kernel/tmp/eupnea-kernel-update/bzImage

# Extract modules and headers into packages
tar xfpJ modules.tar.xz -C eupnea-mainline-kernel-modules/lib/modules
tar xfpJ headers.tar.xz -C eupnea-mainline-kernel-headers/usr/src

# copy debian control files into packages
cp mainline-kernel-control eupnea-mainline-kernel/DEBIAN
cp mainline-kernel-control-modules eupnea-mainline-kernel-modules/DEBIAN
cp mainline-kernel-control-headerpack-mainline-kernel.shs eupnea-mainline-kernel-headers/DEBIAN

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-headers
dpkg-deb --build --root-owner-group -Z=xz eupnea-mainline-modules
