#!/bin/bash

case "$1/$2" in
    pre/suspend)
	echo "Preparing for suspend"
	echo 0 > /sys/power/pm_async
	echo 0 > /sys/class/leds/:white:kbd_backlight/brightness
	systemctl stop NetworkManager
	rfkill block wifi
	rfkill block bluetooth
	modprobe -r brcmfmac_wcc brcmfmac
	;;

    pre/hibernate)
	echo "Preparing for hibernate"
	echo 0 > /sys/power/pm_async
	rmmod -f apple-bce
	rmmod -f applesmc	
	systemctl stop NetworkManager
	rfkill block wifi
	rfkill block bluetooth
	modprobe -r brcmfmac_wcc brcmfmac
	;;

    post/suspend)
	echo "Resuming from suspend"
	rfkill unblock wifi
	rfkill unblock bluetooth
	modprobe brcmfmac brcmfmac_wcc
	systemctl start NetworkManager
	;;
	
    post/hibernate)
	echo "Resuming from hibernate"
	modprobe apple-bce
	modprobe applesmc
	rfkill unblock wifi
	rfkill unblock bluetooth
	modprobe brcmfmac brcmfmac_wcc
	systemctl start NetworkManager
	;;
esac

exit 0
