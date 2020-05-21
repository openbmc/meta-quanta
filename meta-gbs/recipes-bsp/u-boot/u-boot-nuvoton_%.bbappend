DEPENDS += "bison-native bc-native"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=30503fd321432fc713238f582193b78e"
UBRANCH = "npcm7xx-v2019.01"
SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"
UBOOT_MAKE_TARGET_append_gbs = " DEVICE_TREE=${UBOOT_DEVICETREE}"

FILESEXTRAPATHS_prepend_gbs := "${THISDIR}/${PN}:"
SRC_URI_append_gbs = " file://0001-meta-gbs-u-boot-remove-the-setting-of-CONFIG_SYS_MEM.patch"
