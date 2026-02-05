#!/bins/bash -e
systemctl daemon-reload

apt install -y avnav avnav-raspi-base avnav-raspi-network

apt install -y --no-install-recommends avnav-ochartsng avnav-history-plugin avnav-update-plugin avnav-mapproxy-plugin

if [ "$EXTRA_PACKAGES" != "" ] ; then
	echo "$EXTRA_PACKAGES" | tr ',' '\012' | while read pkg
	do
		echo "installing package $pkg"
		if echo "$pkg" | grep -sq '^http' ; then
			pn=/tmp/extra.deb
			[ -f "$pn" ] && rm -f "$pn"
			curl -L -o "$pn" "$pkg" && apt install -y "$pn"
		else
			apt install -y "$pkg"
		fi
	done
fi 
PLUGIN_SCRIPT=/usr/lib/avnav/plugin.sh
if [ -x $PLUGIN_SCRIPT ] ; then
	apt install -y --no-install-recommends avnav-obp-plotterv3-plugin avnav-obp-rc-remote-plugin
	$PLUGIN_SCRIPT hide system-chremote
	$PLUGIN_SCRIPT hide system-obp-plotterv3
fi
MODSCRIPT=/usr/lib/avnav/raspberry/driver/setup.sh
if [ -x $MODSCRIPT ] ; then
	$MODSCRIPT initial image
fi
