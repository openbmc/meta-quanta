FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

UBRANCH = "runbmc_mdio"
SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"
SRCREV = "d9007c733e0941418237e535d025b8f97b5448e1"

SRC_URI += "file://RunBMC-nuvoton-U-boot-setup.patch"

BUILD_CFLAGS_remove = "-isystem${STAGING_INCDIR_NATIVE}"
