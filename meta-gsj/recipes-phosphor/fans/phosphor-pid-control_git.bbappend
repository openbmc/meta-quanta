FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://config-8ssd.json"
SRC_URI += "file://config-2ssd.json"
SRC_URI += "file://fan-control.sh"
SRCREV = "${AUTOREV}"

FILES_${PN} += "${datadir}/swampd/config-8ssd.json"
FILES_${PN} += "${datadir}/swampd/config-2ssd.json"
FILES_${PN} += "${bindir}/fan-control.sh"

inherit obmc-phosphor-systemd
DEPENDS += "cli11"
RDEPENDS_${PN} += "bash"

SYSTEMD_SERVICE_${PN} += "phosphor-pid-control.service"

do_install_append() {
    install -d ${D}${datadir}/swampd

    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-control.sh ${D}/${bindir}

    install -m 0644 -D ${WORKDIR}/config-8ssd.json \
        ${D}${datadir}/swampd/config-8ssd.json
    install -m 0644 -D ${WORKDIR}/config-2ssd.json \
        ${D}${datadir}/swampd/config-2ssd.json
}
