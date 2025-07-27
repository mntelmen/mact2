#!/bin/bash

case "$1" in
	pre)
		echo "Disabling pm_async"
		echo 0 > /sys/power/pm_async

		echo "Stopping iwd"
		#systemctl stop iwd
		systemctl stop NetworkManager

		echo "Unloading brcmfmac modules"
		rfkill block wifi
		rfkill block bluetooth
		modprobe -r brcmfmac_wcc brcmfmac
		;;
	post)
		echo "Re-loading brcmfmac modules"
		rfkill unblock wifi
		rfkill unblock bluetooth
		modprobe brcmfmac brcmfmac_wcc
		echo "Starting iwd"
		systemctl start NetworkManager
		;;
esac

exit 0
