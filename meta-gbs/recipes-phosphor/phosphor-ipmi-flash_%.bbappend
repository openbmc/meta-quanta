FILESEXTRAPATHS_prepend_gbs := "${THISDIR}/${PN}:"

PACKAGECONFIG_append_gbs = " static-bmc reboot-update host-bios"

NUVOTON_FLASH_PCIMBOX = "0xF0848000"

EXTRA_OECONF_append_gbs = " --enable-nuvoton-p2a-mbox"

IPMI_FLASH_BMC_ADDRESS_gbs = "${NUVOTON_FLASH_PCIMBOX}"

