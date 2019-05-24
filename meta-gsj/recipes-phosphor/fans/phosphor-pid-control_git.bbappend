FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://fan-reboot-control.sh"
SRCREV = "${AUTOREV}"

FILES_${PN} += "${bindir}/fan-reboot-control.sh"

inherit obmc-phosphor-systemd
DEPENDS += "cli11"
RDEPENDS_${PN} += "bash"

SYSTEMD_SERVICE_${PN} += "fan-reboot-control.service"

do_install_append() {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-reboot-control.sh ${D}/${bindir}
}
