#!/bin/bash

I2C_BUS=11
CHIP_ADDR=0x15

function set_hotswap()
{
    #set reg "0xd9" bit 3 to 1
    i2cset -f -y $I2C_BUS $CHIP_ADDR 0xd9 0x08
}

function get_hotswap_value()
{
    #get the value of reg "0xd9", return value should be "0x08"
    echo "$(i2cget -f -y $I2C_BUS $CHIP_ADDR 0xd9)"
}

echo "setting hotswap controller..."
set_hotswap

for i in {0..3};
do
    if [ "$i" == "3" ];then
        echo "change hotswap controller setting failed after retry 3 times."
    else
        hotswap_value=$(get_hotswap_value)
        echo "get hotswap controller return value : $hotswap_value"
        if [ "$hotswap_value" == "0x08" ];then
            echo "change hotswap controller setting success."
            break;
        else
            echo "hotswap controller setting failed, retry $i times..."
        fi
    fi
done