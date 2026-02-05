#!/bin/bash -e

on_chroot << EOF
systemctl daemon-reload
systemctl enable canboat.service
EOF

