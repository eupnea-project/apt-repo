#!/bin/bash
# This script will pack the chromeos kernel into 3 debian packages
set -e

# create dirs
mkdir -p eupnea-chromeos-kernel/DEBIAN
mkdir -p eupnea-chromeos-kernel-modules/DEBIAN
mkdir -p eupnea-chromeos-kernel-headers/DEBIAN

mkdir -p eupnea-chromeos-kernel/tmp/eupnea-kernel-update
mkdir -p eupnea-chromeos-kernel-modules/lib/modules
mkdir -p eupnea-chromeos-kernel-headers/usr/src

# Download kernel files
#curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/bzImage -o bzImage
#curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/headers.tar.xz  -o headers.tar.xz
#curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/latest/download/modules.tar.xz -o modules.tar.xz
curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/bzImage -o bzImage
curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/headers.tar.xz -o headers.tar.xz
curl --silent -L https://github.com/eupnea-linux/chromeos-kernel/releases/download/dev-build/modules.tar.xz -o modules.tar.xz

# copy kernel image to package
cp bzImage eupnea-chromeos-kernel/tmp/eupnea-kernel-update/bzImage

# Extract modules and headers into packages
tar xfpJ modules.tar.xz -C eupnea-chromeos-kernel-modules/lib/modules
tar xfpJ headers.tar.xz -C eupnea-chromeos-kernel-headers/usr/src

# copy debian control files into packages
cp chromeos-kernel-control eupnea-chromeos-kernel/DEBIAN
cp chromeos-kernel-control-modules eupnea-chromeos-kernel-modules/DEBIAN
cp chromeos-kernel-control-headerpack-chromeos-kernel.shs eupnea-chromeos-kernel-headers/DEBIAN

# create packages
# by default dpkg-deb will use zstd compression. The deploy action will fail because the debian tool doesnt support zstd compression in packages.
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-headers
dpkg-deb --build --root-owner-group -Z=xz eupnea-chromeos-modules
