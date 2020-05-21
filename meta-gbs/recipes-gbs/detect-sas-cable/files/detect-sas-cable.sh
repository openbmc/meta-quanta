#!/bin/bash

SERVICE_NAME="xyz.openbmc_project.Inventory.Manager"
SAS_CABLE_OBJPATH=("/xyz/openbmc_project/inventory/system/chassis/cable/slimsas_cable0"
"/xyz/openbmc_project/inventory/system/chassis/cable/slimsas_cable1"
"/xyz/openbmc_project/inventory/system/chassis/cable/slimsas_cable2"
"/xyz/openbmc_project/inventory/system/chassis/cable/slimsas_cable3")
INTERFACE_NAME="xyz.openbmc_project.Inventory.Item"

IPMI_LOG_SERVICE="xyz.openbmc_project.Logging.IPMI"
IPMI_LOG_OBJPATH="/xyz/openbmc_project/Logging/IPMI"
IPMI_LOG_INTERFACE="xyz.openbmc_project.Logging.IPMI"
IPMI_LOG_FUNCT="IpmiSelAdd"
IPMI_LOG_PARA_FORMAT="ssaybq" #5 parameters, s : string, s : string, ay : byte array, b : boolean, y : UINT16
LOG_ERR="Cable_error(Incorrect_interconnection)"
LOG_EVENT_DATA="3 0x01 0xff 0xfe"
LOG_ASSERT_FLAG="true"
LOG_DEASSERT_FLAG="false"
LOG_GENID_FLAG="0x0020"
cable_state=("true" "true" "true" "true")

#initial dbus present value
echo "SAS cable state initialize."
while true; do
    for i in {0..3};
    do
    	boot_status=$(busctl get-property $SERVICE_NAME ${SAS_CABLE_OBJPATH[$i]} $INTERFACE_NAME Present | awk '{print $2}')
    	
    	if [ $boot_status == "false" ] && [ ${cable_state[$i]} == "true" ];then
            echo "Update cable $(($i+1)) state."
    	    cable_state[$i]="false"
            busctl call $IPMI_LOG_SERVICE $IPMI_LOG_OBJPATH $IPMI_LOG_INTERFACE $IPMI_LOG_FUNCT $IPMI_LOG_PARA_FORMAT $LOG_ERR ${SAS_CABLE_OBJPATH[$i]} $LOG_EVENT_DATA $LOG_ASSERT_FLAG $LOG_GENID_FLAG
        elif [ $boot_status == "true" ] && [ ${cable_state[$i]} != "true" ];then
            echo "Update cable $(($i+1)) state."
            cable_state[$i]="true"
            busctl call $IPMI_LOG_SERVICE $IPMI_LOG_OBJPATH $IPMI_LOG_INTERFACE $IPMI_LOG_FUNCT $IPMI_LOG_PARA_FORMAT $LOG_ERR ${SAS_CABLE_OBJPATH[$i]} $LOG_EVENT_DATA $LOG_DEASSERT_FLAG $LOG_GENID_FLAG
        fi    
    done
    sleep 1
done

exit 0
