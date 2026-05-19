#!/bin/sh
echo "echo 50 > /sys/class/power_supply/BAT0/charge_control_start_threshold"
echo 50 > /sys/class/power_supply/BAT0/charge_control_start_threshold
echo "echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold"
echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold

