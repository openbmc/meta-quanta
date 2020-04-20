LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"
SRC_URI_append = " file://usb-network.sh"
SRC_URI_append = " file://usb-network.service"
SRC_URI_append = " file://UDC.txt"

inherit systemd

DEPENDS += "systemd"
RDEPENDS_${PN} += "libsystemd"
RDEPENDS_${PN} += "bash"

FILES_${PN}_append = " ${datadir}/usb-network/UDC.txt"
FILES_${PN}_append = " ${sysconfdir_native}/systemd/network/00-bmc-usb0.network"

do_install() {
    install -d ${D}/${sbindir}
    install -m 0755 ${WORKDIR}/usb-network.sh ${D}/${sbindir}

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/usb-network.service \
        ${D}${systemd_unitdir}/system

    install -d ${D}${datadir}/usb-network
    install -m 0644 -D ${WORKDIR}/UDC.txt \
        ${D}${datadir}/usb-network/UDC.txt
}

SYSTEMD_SERVICE_${PN}_append = "usb-network.service"
