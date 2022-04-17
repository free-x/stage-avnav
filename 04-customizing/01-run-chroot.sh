#!/bin/bash -e
dd=/home/pi/avnav/data
if [ ! -d $dd ] ; then
	mkdir -p $dd
fi
cp /usr/lib/avnav/raspberry/avnav_server.xml $dd
if [ -f /etc/systemd/system/signalk.service ] ; then
	sed -iorig '/##.*SIGNALK/d' $dd/avnav_server.xml
fi
if [ -f /etc/default/n2kd ] ; then
	sed -iorig 's/^ *# *CAN_INTERFACE *=.*/CAN_INTERFACE=can0/' /etc/default/n2kd
	sed -iorig '/##.*CANBOAT/d' $dd/avnav_server.xml
fi
DEMOCHART="osm-online.xml"
demosrc=/usr/lib/avnav/viewer/demo/$DEMOCHART
if [ -f $demosrc ] ; then
  dst=$dd/charts
  if [ -d $dst ] ; then
    mkdir -p $dst
  fi
  cp $demosrc $dst
fi
chown -R pi:pi /home/pi/avnav

