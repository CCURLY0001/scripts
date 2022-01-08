#!/bin/bash
# Determines power state of a VM based on a Unique Identifier and boots it if not on
# Designed for ESXi 6.7 U2 and tested on ESXi 6.7 U3

# Designed due to the need of a temporary solution to prevent manual labor and intervention
# while root cause of a recurring crash is determined. Set to run in cron jobs on

# CHANGE VMUNIQUEIDENTIFIER AS NEEDED
# Run vim-cmd vmsvc/getallvms to get a list of all vms and choose an identifying pattern
vmid=$(vim-cmd vmsvc/getallvms | awk '/VMUNIQUEIDENTIFIER/ {print $1}')
vmstatus=$(vim-cmd vmsvc/power.getstate $vmid)

# Check if the VM is powered on
if echo "$vmstatus" | grep -q "off" ; then
	echo "Passed, powering on"
	vim-cmd vmsvc/power.on $vmid
elif echo "$vmstatus" | grep -q "on"; then
	echo "Failed, already powered on"
	break
fi
