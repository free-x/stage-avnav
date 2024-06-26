#!/bin/bash -e
etc_cfg=/etc/avnav_server.xml
cp /usr/lib/avnav/raspberry/avnav_server.xml $etc_cfg
if [ -f /etc/systemd/system/signalk.service ] ; then
	sed -iorig '/##.*SIGNALK/d' $etc_cfg
fi
N2KCFG=/etc/default/n2kd 
if [ -f $N2KCFG ] ; then
        sed -i -e '/CAN_INTERFACE.*/d' $N2KCFG
	echo 'INTERFACE_DEVICE=can0' >> $N2KCFG
	echo 'INTERFACE_PROGRAM=candump' >> $N2KCFG
	echo 'INTERFACE_OPTIONS=" | candump2analyzer"' >> $N2KCFG
	sed -iorig '/##.*CANBOAT/d' $etc_cfg
fi
DEMOCHART="osm-online.xml"
dd=/home/pi/avnav/data
if [ ! -d $dd ] ; then
	mkdir -p $dd
fi
demosrc=/usr/lib/avnav/viewer/demo/$DEMOCHART
if [ -f $demosrc ] ; then
  dst=$dd/charts
  if [ ! -d $dst ] ; then
    mkdir -p $dst
  fi
  if [ -d $dst ] ; then
    cp $demosrc $dst
  fi
fi
chown -R pi:pi /home/pi/avnav

if [ $RELEASE == "bookworm" ]
then
  mv /boot/avnav.conf /boot/firmware/avnav.conf
  ln -sf /boot/firmware/avnav.conf /boot/avnav.conf
fi

if [ "$(dpkg --print-architecture)" == "armhf" ]
then 
  echo "arm_64bit=0" >> /boot/firmware/config.txt
  sed -i "s/arm_64bit=1/arm_64bit=0/g" /boot/firmware/config.txt
fi

if [ $RELEASE == "bookworm" -a "$(dpkg --print-architecture)" == "arm64" ]
then
  echo "kernel=kernel8.img" >> /boot/firmware/config.txt
fi
