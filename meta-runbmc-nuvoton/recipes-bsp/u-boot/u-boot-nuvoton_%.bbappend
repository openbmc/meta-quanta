FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

UBRANCH = "runbmc_mdio"
SRC_URI = "git://github.com/Nuvoton-Israel/u-boot.git;branch=${UBRANCH}"
SRCREV = "d0f08c5697a5502c622029b3efacf36755bf562d"

SRC_URI += "file://0001-update-SPMOD-0-7.patch"