#!/bin/bash

U2_PRESENT_STATUS=( 1 1 1 1 1 1 1 1 )
U2_PRESENT=( 148 149 150 151 152 153 154 155 )
POWER_U2=( 195 196 202 199 198 197 127 126 )
PWRGD_U2=( 161 162 163 164 165 166 167 168 )
RST_BMC_U2=( 72 73 74 75 76 77 78 79 )

function set_gpio_direction(){
    #$1 gpio pin, $2 'in','high','low'
    echo $2 > /sys/class/gpio/gpio$1/direction
}

function read_present_set_related_power(){
    #$1 read present number, $2 output power gpio
    var="${U2_PRESENT_STATUS[$1]}"
    # present 0 is plugged,present 1 is removal
    echo "U2 $i present is ${var}"
    if [ "$var" -eq 0 ];then
        set_gpio_direction $2 "high"
        sleep 0.2
        set_gpio_direction $2 "low"
        sleep 0.2
        set_gpio_direction $2 "high"
    else
        set_gpio_direction $2 "low"
    fi
    sleep 0.2
    echo "U2 set power is $(cat /sys/class/gpio/gpio$2/value)"
}

function update_u2_status(){
  #$1 read present gpio $2 power gpio
  var=$(cat /sys/class/gpio/gpio$2/value)
  U2_PRESENT_STATUS[$1]="$var"
}

function update_u2_direct(){
  U2_PRESENT_STATUS[$1]="$2"
}

function recovery_pwrgd(){
    present=$2
    pwrgd=$(cat /sys/class/gpio/gpio$3/value)
    if [ "$present" -eq "$pwrgd" ];then
        set_gpio_direction "${POWER_U2[$1]}" "low"
        sleep 0.2
        set_gpio_direction "${POWER_U2[$1]}" "high"
        sleep 0.5
        pwrgd=$(cat /sys/class/gpio/gpio$3/value)
        if [ "$present" -eq "$pwrgd" ];then
            #set fault led
            set_gpio_direction $4 "low"
        else
            sleep 0.1
            set_gpio_direction $4 "high"
        fi
    fi
}

function check_present_and_powergood(){
    #$2 present gpio, $3 powergood gpio
    present=$2
    sleep 0.5
    pwrgd=$(cat /sys/class/gpio/gpio$3/value)
    echo "U2 $i present is ${present} and powergood is ${pwrgd}"
    path=`expr $1`
    if [ "$present" -eq 0 ] && [ "$pwrgd" -eq 1 ];then
        sleep 0.1
        set_gpio_direction $4 "high"
    else
        set_gpio_direction $4 "low"
    fi
}

echo "==========Start NVME powermanager service $(date) ==========="

##Initial U2 present status
for i in {0..7};
do 
    update_u2_status $i ${U2_PRESENT[$i]}
done

echo "==========End Update present status $(date) ================="
## Loop while
while :
do
  for i in {0..7};
  do
    ## 1 scend scan all loop
    sleep 0.125
    read=$(cat /sys/class/gpio/gpio${U2_PRESENT[$i]}/value)
    if [ $read -eq 0 ];then 
        recovery_pwrgd $i $read "${PWRGD_U2[$i]}" "${RST_BMC_U2[$i]}"
    fi
    if [ "${U2_PRESENT_STATUS[$i]}" != "$read" ];then
        echo "Update present status"
        update_u2_direct $i "$read"
        read_present_set_related_power $i "${POWER_U2[$i]}"
        check_present_and_powergood $i $read "${PWRGD_U2[$i]}" "${RST_BMC_U2[$i]}"
    fi 
  done
done
