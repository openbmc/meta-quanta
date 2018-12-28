FILESEXTRAPATHS_prepend := "${THISDIR}/linux-nuvoton:"

KBRANCH = "runbmc-nuvoton-4.17.04"
LINUX_VERSION = "4.17.4"

KSRC = "git://github.com/Nuvoton-Israel/linux;protocol=git;branch=${KBRANCH}"
SRCREV = "66aa7b053bf4037d1b3bdc05ec652dad597a846e"

SRC_URI += "file://runbmc-nuvoton.cfg"
