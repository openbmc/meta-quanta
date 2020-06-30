#!/bin/bash

for i in {1..5};
do
    echo 255 > /sys/class/hwmon/*/pwm${i}
    sleep 1
done
