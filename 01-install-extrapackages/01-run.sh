#!/bin/bash -e

on_chroot << EOF
apt-get purge -y rpi-cloud-init-mods cloud-init
apt-get -y autoremove
EOF
