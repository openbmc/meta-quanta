#!/bin/bash

##
#  This script is to handle fan fail condition which is described below.
#  Fan fail means one fan RPM is under its CriticalLow. If BMC encounters
#  such situation, then sets other fans to full speed.
#

failPwm_Off=(40 40)
failPwm_On=(90 90)
fanNum=5

is_fan_fail_flag=0
checkSensorUCT_flag=0
checkNvme_flag=0
func_fail_flag=0
last_func_flag=0
sensorObjPath="/xyz/openbmc_project/sensors/temperature/"
nvmePresentObjPath="/xyz/openbmc_project/inventory/system/chassis/motherboard/"
nvmeService="xyz.openbmc_project.nvme.manager"
nvmePresentService="xyz.openbmc_project.Inventory.Manager"
criticalInf="xyz.openbmc_project.Sensor.Threshold.Critical"
functionIntf="xyz.openbmc_project.State.Decorator.OperationalStatus"
nvmePresentIntf="xyz.openbmc_project.Inventory.Item"
sensorList=(cputemp powerseq_temp vddcr_cpu vddcr_soc vddio_abcd vddio_efgh
    p12v_mobo p12v_fan hotswap)
nvmeList=(nvme0 nvme1 nvme2 nvme3 nvme4 nvme5 nvme6 nvme7 nvme8 nvme9 nvme10
    nvme11 nvme12 nvme13 nvme14 nvme15)

fan_tach_path=(
    '/xyz/openbmc_project/sensors/fan_tach/fan0'
    '/xyz/openbmc_project/sensors/fan_tach/fan1'
    '/xyz/openbmc_project/sensors/fan_tach/fb_fan0'
    '/xyz/openbmc_project/sensors/fan_tach/fb_fan1'
    '/xyz/openbmc_project/sensors/fan_tach/fb_fan2'
)

Fan_0_To_4_Hwmon="$(ls -la /sys/class/hwmon | grep pwm | head -n 1 | tail -n +1 | cut -d '/' -f 9)"
Fan_0_To_4_Path="/sys/devices/platform/ahb/ahb:apb/f0103000.pwm-fan-controller/hwmon/${Fan_0_To_4_Hwmon}/"

# get fan/sensor Critical/Warning/Functional state
function get_state() {
    state="$(busctl get-property $1 $2 $3 $4 | awk '{print $2}')"
    echo "$state"
}

function get_host_state() {
    state=$(busctl get-property \
        xyz.openbmc_project.State.Host \
        /xyz/openbmc_project/state/os \
        xyz.openbmc_project.State.OperatingSystem.Status \
        OperatingSystemState | cut -d '"' -f 2 | awk -F . '{print $NF}')
    echo $state
}

function set_fans_pwm() {
    pwmduty=($@)
    for ((i = 1; i <= ${fanNum}; i++)); do
        if [ $i -le 2 ]; then
            pwmFile=${Fan_0_To_4_Path}pwm${i}
            dutyval=$((${pwmduty[0]} * 255 / 100))
            echo $dutyval >$pwmFile
        else
            pwmFile=${Fan_0_To_4_Path}pwm${i}
            dutyval=$((${pwmduty[1]} * 255 / 100))
            echo $dutyval >$pwmFile
        fi
    done
}

# check fan/sensor fail
function is_fail() {
    state=("$@")

    for i in "${state[@]}"; do
        if [ ! -z "$i" ]; then
            if [ $i == "true" ]; then
                echo 1
                return
            fi
        fi
    done
    echo 0
}

while true; do
    current_fan_state=()
    current_sensor_state=()
    sensor_func_state=()
    current_nvme_state=()

    # check fan fail or not
    for i in ${!fan_tach_path[@]}; do
        mapper wait ${fan_tach_path[$i]}
        hwmon_path="$(mapper get-service ${fan_tach_path[$i]})"
        current_fan_state[$i]=$(get_state $hwmon_path ${fan_tach_path[$i]} $criticalInf CriticalAlarmLow)
    done

    is_fan_fail_flag=$(is_fail "${current_fan_state[@]}")

    # check sensor fail or not
    for i in ${!sensorList[@]}; do
        sensorPath=${sensorObjPath}${sensorList[$i]}
        {
            sensorService=$(mapper get-service ${sensorPath} 2>/dev/null)
        } && {
            current_sensor_state[$i]=$(get_state $sensorService $sensorPath $criticalInf CriticalAlarmHigh)
            funcState=$(get_state $sensorService $sensorPath $functionIntf Functional)
        }
        if [ -z ${current_sensor_state[$i]} ]; then
            current_sensor_state[$i]="true"
            sensor_func_state[$i]="true"
        elif [[ $funcState == "false" ]]; then
            sensor_func_state[$i]="true"
        elif [[ $funcState == "true" ]]; then
            sensor_func_state[$i]="false"
        fi
    done

    # check nvme fail or not
    for i in ${!nvmeList[@]}; do
        sensorPath=${sensorObjPath}${nvmeList[$i]}
        nvmePresentPath=${nvmePresentObjPath}${nvmeList[$i]}
        {
            sensorService=$(mapper get-service ${sensorPath} 2>/dev/null)
        } && {
            UCTstate=$(get_state $nvmeService $sensorPath $criticalInf CriticalAlarmHigh)
            LCTstate=$(get_state $nvmeService $sensorPath $criticalInf CriticalAlarmLow)
            if [[ $UCTstate == "true" ]] || [[ $LCTstate == "true" ]]; then
                current_nvme_state[$i]="true"
            else
                current_nvme_state[$i]="false"
            fi
        }
        nvme_present_state=$(get_state $nvmePresentService $nvmePresentPath $nvmePresentIntf Present)
        if [[ $nvme_present_state == "false" ]]; then
            current_nvme_state[$i]="false"
        elif [ -z ${current_nvme_state[$i]} ]; then
            current_nvme_state[$i]="true"
        fi
    done

    checkSensorUCT_flag=$(is_fail "${current_sensor_state[@]}")
    checkNvme_flag=$(is_fail "${current_nvme_state[@]}")

    current_func_flag=$(is_fail "${sensor_func_state[@]}")
    func_fail_flag=$(($last_func_flag & $current_func_flag))

    last_func_flag=$current_func_flag

    # if any flag = 1, go fan fail
    if [ $checkSensorUCT_flag -eq 0 ] &&
        [ $checkNvme_flag -eq 0 ] &&
        [ $is_fan_fail_flag -eq 0 ] &&
        [ $func_fail_flag -eq 0 ]; then
        if [ $(systemctl is-active phosphor-pid-control.service) == "inactive" ]; then
            echo "Restore pid-control service"
            systemctl restart phosphor-pid-control
        fi
    elif [ $checkSensorUCT_flag -eq 1 ] ||
        [ $checkNvme_flag -eq 1 ] ||
        [ $is_fan_fail_flag -eq 1 ] ||
        [ $func_fail_flag -eq 1 ]; then
        if [ $(systemctl is-active phosphor-pid-control.service) == "active" ]; then
            echo "detect sensor/fan fail, stopping pid-control service"
            systemctl stop phosphor-pid-control
        fi
        if [[ $(get_host_state) == "Inactive" ]]; then
            set_fans_pwm ${failPwm_Off[@]}
        elif [[ $(get_host_state) == "Standby" ]]; then
            set_fans_pwm ${failPwm_On[@]}
        fi
    fi

    sleep 2
done
