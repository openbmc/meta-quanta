#!/bin/bash

mac_config="/usr/share/mac-address/config.txt"
dev_mac_path="/tmp/usb0_dev"
host_mac_path="/tmp/usb0_host"

check_usb_local_administered() {
    is_enable="$(cat ${mac_config} | grep 'USBLAA')"
    echo ${is_enable}
}

set_local_administered_bit() {
    mac=$(cat $1 | tr -d ':')
    s=${mac:0:2}
    s=$((0x$s|2))
    macdec=$(printf "%02x\n" "$s")
    for((i=2;i<${#mac};i+=2))
    do
        macdec=$macdec:${mac:$i:2}
    done
    echo $macdec
}

cd /sys/kernel/config/usb_gadget

if [ ! -f "g1" ]; then
    mkdir g1
    cd g1

    echo 0x1d6b > idVendor  # Linux foundation
    echo 0x0104 > idProduct # Multifunction composite gadget
    mkdir -p strings/0x409
    echo "Linux" > strings/0x409/manufacturer
    echo "Etherned/ECM gadget" > strings/0x409/product

    mkdir -p configs/c.1
    echo 100 > configs/c.1/MaxPower
    mkdir -p configs/c.1/strings/0x409
    echo "ECM" > configs/c.1/strings/0x409/configuration


    if [[ $(check_usb_local_administered) == "USBLAA=true" ]]; then
        dev_mac="$(set_local_administered_bit $dev_mac_path)"
        host_mac="$(set_local_administered_bit $host_mac_path)"
        echo $dev_mac > $dev_mac_path
        echo $host_mac > $host_mac_path
    fi

    mkdir -p functions/ecm.usb0
    cat $dev_mac_path > functions/ecm.usb0/dev_addr # write device mac address
    cat $host_mac_path > functions/ecm.usb0/host_addr # write usb mac address

    ln -s functions/ecm.usb0 configs/c.1

    echo "$UDC" > UDC

    rm $dev_mac_path
    rm $host_mac_path

fi

exit 0
