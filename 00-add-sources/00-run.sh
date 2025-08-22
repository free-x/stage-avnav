#!/bin/bash -e

install -m 644 files/oss.boating.gpg "${ROOTFS_DIR}/usr/share/keyrings"
install -m 644 files/extra.sources "${ROOTFS_DIR}/etc/apt/sources.list.d/"
sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/extra.sources"
sed -i "s/ARCH/${ARCH}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/extra.sources"

if [ "$AVNAV_DAILY" == "1" ] ; then
    sed -i "s/^#//g" "${ROOTFS_DIR}/etc/apt/sources.list.d/extra.sources"
fi
  

on_chroot << EOF
apt-get update
EOF
