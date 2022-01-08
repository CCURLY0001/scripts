#!/bin/sh
# Determines power state of a VM based on a Unique Identifier and boots it if not on

esxcli system syslog mark --message="Running cron job for script powerOnVM.sh"

# CHANGE VMUNIQUEIDENTIFIER AS NEEDED
# Run vim-cmd vmsvc/getallvms to get a list of all vms and choose an identifying pattern
vmid=$(vim-cmd vmsvc/getallvms | awk '/VMUNIQUEIDENTIFIER/ {print $1}')
vmstatus=$(vim-cmd vmsvc/power.getstate $vmid)

# Check if the VM is powered on
if echo "$vmstatus" | grep -q "off" ; then
	esxcli system syslog mark --message="VM Detected as off. Attempting to boot VM."
	vim-cmd vmsvc/power.on $vmid
elif echo "$vmstatus" | grep -q "on"; then
	esxcli system syslog mark --message="VM Detected as on. Exiting job."
	break
else
	esxcli system syslog mark --message="Error running script - Exiting"
	break
fi
