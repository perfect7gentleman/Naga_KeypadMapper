#!/bin/bash
# All supported devices listed in README. If you want to add another device, please check the naga.cpp source code!
# Disabled next two lines from ioctl change.
# NAGAID1=$(xinput | grep Naga | grep keyboard | cut -d= -f2 | cut -b1-2)
# xinput set-int-prop $NAGAID1 "Device Enabled" 8 0
 
# Insanity, just because naga 2014
NAGAID2=$(xinput | grep xwayland | grep pointer | cut -d= -f2 | cut -f1)
if [[ `echo $NAGAID2 | wc -w` -eq 2 ]]; then
if [[ `xinput get-button-map $(echo $NAGAID2 | awk '{print $1}') | grep 10 | wc -l` -eq 1 ]]; then
xinput set-button-map $(echo $NAGAID2 | awk '{print $1}') 1 2 3 4 5 6 7 11 10 8 9 13 14 15
else
xinput set-button-map $(echo $NAGAID2 | awk '{print $2}') 1 2 3 4 5 6 7 11 10 8 9 13 14 15
fi
else
xinput set-button-map $NAGAID2 1 2 3 4 5 6 7 11 10 8 9 13 14 15
fi

# Run daemon
naga
