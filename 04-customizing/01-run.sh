#!/bin/bash -e

install -v -m 775 -o 1000 -g 1000 files/uart_control "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/"

#install -v -m 755 -o 0 -g 0 files/rc.local "${ROOTFS_DIR}/etc/"

on_chroot << EOF
echo "set mouse-=a" >> /home/pi/.vimrc
echo "set mouse-=a" >> /root/.vimrc
EOF
