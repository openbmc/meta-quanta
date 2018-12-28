FILESEXTRAPATHS_prepend := "${THISDIR}/linux-nuvoton:"

KBRANCH = "Poleg-4.17.04-OpenBMC"
LINUX_VERSION = "4.17.4"

KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=git;branch=${KBRANCH}"
SRCREV = "d1a847c64022826ef1bd61be2def8e57a1aca300"

SRC_URI += "file://nuvoton-runbmc.cfg"
SRC_URI += "file://enable-vcd-ece.cfg"
SRC_URI += "file://0002-nbd-fix-reconnect.patch"
SRC_URI += "file://0001-run-bmc-bringup.patch"
