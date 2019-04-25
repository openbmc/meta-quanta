#!/bin/bash

source $(dirname $0)/nvme_powerctrl_library.sh

function set_gpio() {
  #$1 gpio pin
  echo $1 > /sys/class/gpio/export
}

echo "Read Clock Gen Value is: $CLOCK_GEN_VALUE"

## Initial U2_PRESENT_N
for i in ${!U2_PRESENT[@]};
do
    set_gpio ${U2_PRESENT[$i]};
    set_gpio_direction ${U2_PRESENT[$i]} 'in';
    echo "Read $i SSD present: $(read_gpio_input ${U2_PRESENT[$i]})"
done

## Initial POWER_U2_EN
for i in ${!POWER_U2[@]};
do
    set_gpio ${POWER_U2[$i]};
done

## Initial PWRGD_U2
for i in ${!PWRGD_U2[@]};
do
    set_gpio ${PWRGD_U2[$i]};
    set_gpio_direction ${PWRGD_U2[$i]} 'in';
    echo "Read $i SSD Power Good: $(read_gpio_input ${PWRGD_U2[$i]})"
done

## Initial RST_BMC_U2
for i in ${!RST_BMC_U2[@]};
do
    set_gpio ${RST_BMC_U2[$i]};
done

### Initial related Power by Present
for i in {0..7};
do
    if [ $(read_gpio_input ${U2_PRESENT[$i]}) == $PLUGGED ];then
        update_clock_gen_chip_register $i 1
    else
        disable_nvme_power $i
    fi
done

echo "Read Clock Gen Value again is: $CLOCK_GEN_VALUE"

exit 0;
