#!/bin/bash
for i in {1..5}; do echo 255 > /sys/devices/platform/ahb/ahb\:apb/f0103000.pwm-fan-controller/hwmon/*/pwm${i}; sleep 1; done
