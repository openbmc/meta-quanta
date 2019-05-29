#!/bin/bash

# get fan threshold by d-bus command
function get_threshold_value() {
    get_property_path='xyz.openbmc_project.Sensor.Threshold.Critical CriticalLow'
    threshold_value="$(busctl get-property $1 $2 $get_property_path | awk '{print $2}')"
    echo "$threshold_value"
}

# get fan rpm by d-bus command
function get_fan_value() {
    get_property_path='xyz.openbmc_project.Sensor.Value Value'
    fan_value="$(busctl get-property $1 $2 $get_property_path | awk '{print $2}')"
    echo "$fan_value"
}

# set fan pwm by d-bus command
function set_fan_value() {
    set_property_path='xyz.openbmc_project.Control.FanPwm'
    busctl set-property $1 $2 $set_property_path Target t 255
}

#find hwmon path of fan
function find_hwmon_path() {
    # calculate number of hwmons
    hwmon_num="$(ls /sys/class/hwmon/ | awk '{count+= 1} END {print count}')"
    for i in $(seq 1 $hwmon_num); 
    do 
        #combine number + p
        i+="p"
        #get path of hwmon
        path="$(busctl --no-pager | grep Hwmon[0-9] | awk '{print $1}' | sed -n "$i")" 
        #perform busctl tree to show content of each path of hwmon, and grep fan_tach
        busctl_tree="$(busctl tree $path --no-pager | grep fan_tach)"
        # $? is used to record last command state
        if [ $? -eq 0 ];then
            echo "$path"
        fi
    done
}

fan_tach_path=( '/xyz/openbmc_project/sensors/fan_tach/Fan0_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan0_1_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan1_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan1_1_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan2_0_RPM'
                '/xyz/openbmc_project/sensors/fan_tach/Fan2_1_RPM'
                )

hwmon_path=$(find_hwmon_path)
critical_threshold=$(get_threshold_value $hwmon_path ${fan_tach_path[0]})
check_fail_flag=0
current_fan_value=()
while true; do
    for i in ${!fan_tach_path[@]};
    do
        current_fan_value[$i%2]=$(get_fan_value $hwmon_path ${fan_tach_path[$i]})
        #Compare real rpm of dual rotor with critical_threshold to check if fan faii  
        if [ ${#current_fan_value[@]} -eq 2 ];then
            if [ ${current_fan_value[0]} -lt $critical_threshold ] && [ ${current_fan_value[1]} -lt $critical_threshold ] ;then
                if [ $check_fail_flag -eq 0 ];then
                    systemctl stop phosphor-pid-control
                    for j in ${!fan_tach_path[@]};
                    do
                        #If fan fail is detect, set other fan rpm to pwm 255.
                        set_fan_value $hwmon_path ${fan_tach_path[$j]}
                        check_fail_flag=1
                    done
                fi
                current_fan_value=()
                break
            fi
            current_fan_value=()
        fi

        #fans are going to normal.
        if [ $i -eq $((${#fan_tach_path[@]}-1)) ] && [ $check_fail_flag -eq 1 ]; then
           check_fail_flag=0
           systemctl restart phosphor-pid-control
        fi
    done
    sleep 2
done
