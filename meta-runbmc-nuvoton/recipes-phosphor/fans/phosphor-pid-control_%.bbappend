FILESEXTRAPATHS_prepend_runbmc-nuvoton += "${THISDIR}/${PN}:"

SRC_URI_append_runbmc-nuvoton = " file://config-runbmc-nuvoton.json"
SRC_URI_append_runbmc-nuvoton = " file://fan-full-speed.sh"
SRC_URI_append_runbmc-nuvoton = " file://phosphor-pid-control.service"
SRC_URI_append_runbmc-nuvoton = " file://fan-reboot-control.service"

FILES_${PN}_append_runbmc-nuvoton = " ${bindir}/fan-full-speed.sh"
FILES_${PN}_append_runbmc-nuvoton = " ${datadir}/swampd/config.json"

RDEPENDS_${PN} += "bash"

SYSTEMD_SERVICE_${PN}_append_runbmc-nuvoton = " phosphor-pid-control.service"
SYSTEMD_SERVICE_${PN}_append_runbmc-nuvoton = " fan-reboot-control.service"

do_install_append_runbmc-nuvoton() {
    install -d ${D}/${bindir}
    install -m 0755 ${WORKDIR}/fan-full-speed.sh ${D}/${bindir}

    install -d ${D}${datadir}/swampd
    install -m 0644 -D ${WORKDIR}/config-runbmc-nuvoton.json \
        ${D}${datadir}/swampd/config.json

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/phosphor-pid-control.service \
        ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/fan-reboot-control.service \
        ${D}${systemd_unitdir}/system
}
