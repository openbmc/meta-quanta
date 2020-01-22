#!/bin/bash

KL0_path='/xyz/openbmc_project/sensors/temperature/KL0'
property_path='xyz.openbmc_project.Sensor.Value'
while true; do
    hwmon_path="$(mapper get-service ${KL0_path})"
    pwm=$(($(cat /sys/class/hwmon/*/pwm1)*100/255))
    kl0_value=$(cat /sys/devices/platform/ahb/ahb\:apb/f0081000.i2c/i2c-1/1-005c/hwmon/hwmon0/temp1_input)
    if [ $pwm -lt 30 ];then
        kl0_value=$(($kl0_value-2000))
    elif [ $pwm -gt 49 ]; then
        :
    else
        kl0_value=$(($kl0_value-1000))
    fi
    busctl set-property $hwmon_path $KL0_path $property_path Value x $kl0_value
    sleep 2
done
