FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = "file://config-8ssd.json"
SRC_URI_append_gsj = "file://config-2ssd.json"
SRC_URI_append_gsj = "file://fan-control.sh"
SRC_URI_append_gsj = "file://fan-full-speed.sh"

FILES_${PN} += "${datadir}/swampd/config-8ssd.json"
FILES_${PN} += "${datadir}/swampd/config-2ssd.json"
FILES_${PN} += "${bindir}/fan-control.sh"
FILES_${PN} += "${bindir}/fan-full-speed.sh"

inherit obmc-phosphor-systemd
RDEPENDS_${PN} += "bash"

SYSTEMD_SERVICE_${PN} += "phosphor-pid-control.service"
SYSTEMD_SERVICE_${PN} += "fan-reboot-control.service"

do_install_append_gsj() {
    install -d ${D}${datadir}/swampd

    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-control.sh ${D}/${bindir}

    install -m 0644 -D ${WORKDIR}/config-8ssd.json \
        ${D}${datadir}/swampd/config-8ssd.json
    install -m 0644 -D ${WORKDIR}/config-2ssd.json \
        ${D}${datadir}/swampd/config-2ssd.json

    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-full-speed.sh ${D}/${bindir}
}
