#!/bin/bash -e

if [ ${RELEASE} == "buster" ]
then
  install -m 644 files/extra.list "${ROOTFS_DIR}/etc/apt/sources.list.d/"
  on_chroot apt-key add - < files/oss.boating.gpg.key
  #on_chroot apt-key add - < files/open-mind.space.gpg.key
else
  install -m 644 files/extra-bullseye.list "${ROOTFS_DIR}/etc/apt/sources.list.d/extra.list"
  install -m 644 files/oss.boating.gpg "${ROOTFS_DIR}/usr/share/keyrings"
fi

sed -i "s/RELEASE/${RELEASE}/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/extra.list"

if [ "$AVNAV_DAILY" == "1" ] ; then
  sed -i "s/#deb/deb/g" "${ROOTFS_DIR}/etc/apt/sources.list.d/extra.list"
fi
  

on_chroot << EOF
apt-get update
EOF
