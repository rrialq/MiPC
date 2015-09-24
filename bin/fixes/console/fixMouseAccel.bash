#!/bin/bash

while [ true ]; do
	xinput --set-prop "Logitech Unifying Device. Wireless PID:1025" "Device Accel Velocity Scaling" 7
	sleep 30
done
