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
    else
        set_gpio_direction $3 "low"
        sleep 0.1
        write_clock_gen_chip_0_register $1
        sleep 0.005
        set_gpio_direction $2 "low"
    fi
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
        sleep 0.2
        pwrgd=$(cat /sys/class/gpio/gpio$3/value)
        if [ "$present" -eq "$pwrgd" ];then
            write_clock_gen_chip_0_register $1
            set_gpio_direction $4 "low"
        else
            sleep 0.005
            write_clock_gen_chip_1_register $1
            sleep 0.1
            set_gpio_direction $4 "high"
        fi
    fi
}


function write_clock_gen_chip_1_register(){
    clock_gen_value=$(i2cget -y 8 0x68 0 i 2|sed 's/[0-9]: 0x[0-9a-zA-Z][0-9a-zA-Z] //g')
    update_value=$(printf '%x\n' "$((0x01 <<$1))")
    write_value=$(printf '0x%x\n' "$(($clock_gen_value | 0x$update_value))")
    i2cset -y 8 0x68 0 $write_value s
}


function write_clock_gen_chip_0_register(){
    clock_gen_value=$(i2cget -y 8 0x68 0 i 2|sed 's/[0-9]: 0x[0-9a-zA-Z][0-9a-zA-Z] //g')
    update_value=$(printf '%x\n' "$((0x01 <<$1))")
    verbose_update_value=$(printf '%x\n' "$((~0x$update_value))"|sed 's/ffffffffffffff//g')
    write_value=$(printf '0x%x\n' "$(($clock_gen_value & 0x$verbose_update_value))")
    i2cset -y 8 0x68 0 $write_value s

}


function check_present_and_powergood(){
    #$2 present gpio, $3 powergood gpio
    present=$2
    sleep 0.5
    pwrgd=$(cat /sys/class/gpio/gpio$3/value)
    echo "U2 $i present is ${present} and powergood is ${pwrgd}"
    path=`expr $1`
    if [ "$present" -eq 0 ] && [ "$pwrgd" -eq 1 ];then
        sleep 0.01
        write_clock_gen_chip_1_register $1
        sleep 0.1
        set_gpio_direction $4 "high"
    else
        write_clock_gen_chip_0_register $1
        set_gpio_direction $4 "low"
    fi
}


##Initial U2 present status
for i in {0..7};
do 
    update_u2_status $i ${U2_PRESENT[$i]}
done


## Loop while
while :
do
  for i in {0..7};
  do
    ## 1 scend scan all loop
    sleep 0.125
    read=$(cat /sys/class/gpio/gpio${U2_PRESENT[$i]}/value)
    if [ $read -eq 0 ] && [ ${U2_PRESENT_STATUS[$i]} -eq 0 ];then
        recovery_pwrgd $i $read "${PWRGD_U2[$i]}" "${RST_BMC_U2[$i]}"
    fi
    if [ "${U2_PRESENT_STATUS[$i]}" != "$read" ];then
        echo "Update present status"
        update_u2_direct $i "$read"
        read_present_set_related_power $i "${POWER_U2[$i]}" "${RST_BMC_U2[$i]}"
        if [ $read -eq 0 ];then
            check_present_and_powergood $i $read "${PWRGD_U2[$i]}" "${RST_BMC_U2[$i]}"
        fi
    fi
  done
done
