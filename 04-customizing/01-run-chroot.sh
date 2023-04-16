#!/bin/bash -e
dd=/home/pi/avnav/data
if [ ! -d $dd ] ; then
	mkdir -p $dd
fi
cp /usr/lib/avnav/raspberry/avnav_server.xml $dd
if [ -f /etc/systemd/system/signalk.service ] ; then
	sed -iorig '/##.*SIGNALK/d' $dd/avnav_server.xml
fi
N2KCFG=/etc/default/n2kd 
if [ -f $N2KCFG ] ; then
	echo 'INTERFACE_DEVICE=can0' >> $N2KCFG
	echo 'INTERFACE_PROGRAM=candump' >> $N2KCFG
	echo 'INTERFACE_OPTIONS=" | candump2analyzer"' >> $N2KCFG
	sed -iorig '/##.*CANBOAT/d' $dd/avnav_server.xml
fi
DEMOCHART="osm-online.xml"
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

if [ "$(dpkg --print-architecture) == "armhf" ]
then 
  echo "arm_64bit=0" >> /boot/config.txt
  sed -i "s/arm_64bit=1/arm_64bit=0/g" /boot/config.txt
fi
