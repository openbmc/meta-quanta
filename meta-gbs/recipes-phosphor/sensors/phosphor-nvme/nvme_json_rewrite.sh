#!/bin/bash

TARGET_FILE_NAME="/etc/nvme/nvme_config.json"

export_gpio() {
  if [ ! -d "/sys/class/gpio/gpio$1" ]; then
    echo $1 >/sys/class/gpio/export
  fi
}

get_gpio_value() {
    echo "$(cat /sys/class/gpio/gpio$1/value)"
}

HSBP_CABLE_PRSNT_BUF_N=57
export_gpio ${HSBP_CABLE_PRSNT_BUF_N}

hsbp_prsnt="$(get_gpio_value $HSBP_CABLE_PRSNT_BUF_N)"
if [[ ${hsbp_prsnt} != 0 ]]; then
    echo "HSBP board sideband cable not present !!"
    exit 1
fi

# Get NVMeDriveBusIDs
# 6-0073
# 7-0072
# 10-0071
# 14-0070
I2C6_MUX_SYSPATH="/sys/bus/i2c/drivers/pca954x/6-0073/"
I2C7_MUX_SYSPATH="/sys/bus/i2c/drivers/pca954x/7-0072/"
I2C10_MUX_SYSPATH="/sys/bus/i2c/drivers/pca954x/10-0071/"
I2C14_MUX_SYSPATH="/sys/bus/i2c/drivers/pca954x/14-0070/"

if [ -d ${I2C6_MUX_SYSPATH} ]; then
    I2C6_BASE="$(ls -la ${I2C6_MUX_SYSPATH} | grep channel-0 \
                | awk -F '/' '{print $2}' | awk -F '-' '{print $2}')"
    Index_BusID[0]=$I2C6_BASE
    let Index_BusID[1]=$I2C6_BASE+1
    let Index_BusID[2]=$I2C6_BASE+2
    let Index_BusID[3]=$I2C6_BASE+3
else
    echo "Can't find ${I2C6_MUX_SYSPATH}"
fi

if [ -d ${I2C7_MUX_SYSPATH} ]; then
    I2C7_BASE="$(ls -la ${I2C7_MUX_SYSPATH} | grep channel-0 \
                | awk -F '/' '{print $2}' | awk -F '-' '{print $2}')"
    Index_BusID[4]=$I2C7_BASE
    let Index_BusID[5]=$I2C7_BASE+1
    let Index_BusID[6]=$I2C7_BASE+2
    let Index_BusID[7]=$I2C7_BASE+3
else
    echo "Can't find ${I2C7_MUX_SYSPATH}"
fi

if [ -d ${I2C10_MUX_SYSPATH} ]; then
    I2C10_BASE="$(ls -la ${I2C10_MUX_SYSPATH} | grep channel-0 \
                 | awk -F '/' '{print $2}' | awk -F '-' '{print $2}')"
    Index_BusID[8]=$I2C10_BASE
    let Index_BusID[9]=$I2C10_BASE+1
    let Index_BusID[10]=$I2C10_BASE+2
    let Index_BusID[11]=$I2C10_BASE+3
else
    echo "Can't find ${I2C10_MUX_SYSPATH}"
fi

if [ -d ${I2C14_MUX_SYSPATH} ]; then
    I2C14_BASE="$(ls -la ${I2C14_MUX_SYSPATH} | grep channel-0 \
                 | awk -F '/' '{print $2}' | awk -F '-' '{print $2}')"
    Index_BusID[12]=$I2C14_BASE
    let Index_BusID[13]=$I2C14_BASE+1
    let Index_BusID[14]=$I2C14_BASE+2
    let Index_BusID[15]=$I2C14_BASE+3
else
    echo "Can't find ${I2C14_MUX_SYSPATH}"
fi

# Get NVMeDrivePresentPins
# 1-0024

# Get NVMeDrivePwrGoodPins
# 1-0021

presentPinBase="$(cat /sys/bus/i2c/drivers/pca953x/1-0024/gpio/gpiochip*/base)"
if [[ $presentPinBase =~ ^[0-9]+$ ]]; then
    for i in {0..15};
    do
        let presentPinBase[$i]=presentPinBase+$i
        export_gpio ${presentPinBase[$i]}
    done
else
    echo "Can't find nvme present gpiochip base !!"
    exit 1
fi

PwrGoodPinBase="$(cat /sys/bus/i2c/drivers/pca953x/1-0021/gpio/gpiochip*/base)"
if [[ $PwrGoodPinBase =~ ^[0-9]+$ ]]; then
    for i in {0..15};
    do
        let PwrGoodPinBase[$i]=PwrGoodPinBase+$i
        export_gpio ${PwrGoodPinBase[$i]}
    done
else
    echo "Can't find nvme powergood gpiochip base !!"
    exit 1
fi

cat > $TARGET_FILE_NAME << EOF1
{
    "config": [
        {
            "NVMeDriveIndex": 0,
            "NVMeDriveBusID": ${Index_BusID[0]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_0_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_0_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_0_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_0_locate",
            "NVMeDrivePresentPin": ${presentPinBase[0]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[0]}
        },
        {
            "NVMeDriveIndex": 1,
            "NVMeDriveBusID": ${Index_BusID[1]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_1_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_1_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_1_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_1_locate",
            "NVMeDrivePresentPin": ${presentPinBase[1]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[1]}
        },
        {
            "NVMeDriveIndex": 2,
            "NVMeDriveBusID": ${Index_BusID[2]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_2_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_2_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_2_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_2_locate",
            "NVMeDrivePresentPin": ${presentPinBase[2]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[2]}
        },
        {
            "NVMeDriveIndex": 3,
            "NVMeDriveBusID": ${Index_BusID[3]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_3_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_3_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_3_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_3_locate",
            "NVMeDrivePresentPin": ${presentPinBase[3]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[3]}
        },
        {
            "NVMeDriveIndex": 4,
            "NVMeDriveBusID": ${Index_BusID[4]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_4_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_4_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_4_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_4_locate",
            "NVMeDrivePresentPin": ${presentPinBase[4]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[4]}
        },
        {
            "NVMeDriveIndex": 5,
            "NVMeDriveBusID": ${Index_BusID[5]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_5_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_5_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_5_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_5_locate",
            "NVMeDrivePresentPin": ${presentPinBase[5]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[5]}
        },
        {
            "NVMeDriveIndex": 6,
            "NVMeDriveBusID": ${Index_BusID[6]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_6_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_6_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_6_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_6_locate",
            "NVMeDrivePresentPin": ${presentPinBase[6]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[6]}
        },
        {
            "NVMeDriveIndex": 7,
            "NVMeDriveBusID": ${Index_BusID[7]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_7_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_7_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_7_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_7_locate",
            "NVMeDrivePresentPin": ${presentPinBase[7]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[7]}
        },
        {
            "NVMeDriveIndex": 8,
            "NVMeDriveBusID": ${Index_BusID[8]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_8_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_8_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_8_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_8_locate",
            "NVMeDrivePresentPin": ${presentPinBase[8]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[8]}
        },
        {
            "NVMeDriveIndex": 9,
            "NVMeDriveBusID": ${Index_BusID[9]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_9_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_9_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_9_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_9_locate",
            "NVMeDrivePresentPin": ${presentPinBase[9]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[9]}
        },
        {
            "NVMeDriveIndex": 10,
            "NVMeDriveBusID": ${Index_BusID[10]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_10_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_10_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_10_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_10_locate",
            "NVMeDrivePresentPin": ${presentPinBase[10]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[10]}
        },
        {
            "NVMeDriveIndex": 11,
            "NVMeDriveBusID": ${Index_BusID[11]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_11_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_11_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_11_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_11_locate",
            "NVMeDrivePresentPin": ${presentPinBase[11]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[11]}
        },
        {
            "NVMeDriveIndex": 12,
            "NVMeDriveBusID": ${Index_BusID[12]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_12_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_12_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_12_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_12_locate",
            "NVMeDrivePresentPin": ${presentPinBase[12]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[12]}
        },
        {
            "NVMeDriveIndex": 13,
            "NVMeDriveBusID": ${Index_BusID[13]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_13_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_13_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_13_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_13_locate",
            "NVMeDrivePresentPin": ${presentPinBase[13]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[13]}
        },
        {
            "NVMeDriveIndex": 14,
            "NVMeDriveBusID": ${Index_BusID[14]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_14_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_14_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_14_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_14_locate",
            "NVMeDrivePresentPin": ${presentPinBase[14]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[14]}
        },
        {
            "NVMeDriveIndex": 15,
            "NVMeDriveBusID": ${Index_BusID[15]},
            "NVMeDriveFaultLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_15_fault",
            "NVMeDriveLocateLEDGroupPath": "/xyz/openbmc_project/led/groups/led_u2_15_locate",
            "NVMeDriveLocateLEDControllerBusName": "xyz.openbmc_project.LED.Controller.led_u2_15_locate",
            "NVMeDriveLocateLEDControllerPath": "/xyz/openbmc_project/led/physical/led_u2_15_locate",
            "NVMeDrivePresentPin": ${presentPinBase[15]},
            "NVMeDrivePwrGoodPin": ${PwrGoodPinBase[15]}
        }
    ],
    "threshold": [
        {
            "criticalHigh": 70,
            "criticalLow": 0,
            "warningHigh": 70,
            "warningLow": 0,
            "maxValue": 127,
            "minValue": -128
        }
    ]
}
EOF1
