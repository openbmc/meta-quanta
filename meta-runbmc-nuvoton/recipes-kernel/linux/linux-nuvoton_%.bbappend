FILESEXTRAPATHS_prepend := "${THISDIR}/linux-nuvoton:"

KBRANCH = "runbmc-nuvoton-4.17.04"
LINUX_VERSION = "4.17.4"

KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=git;branch=${KBRANCH}"
SRCREV = "901ab17672cc901fa5c48a64f1614e966ceece20"

SRC_URI += "file://runbmc-nuvoton.cfg"
SRC_URI += "file://nbd-fix-reconnect.patch"
SRC_URI += "file://0001-Update-SPI-label.patch"
