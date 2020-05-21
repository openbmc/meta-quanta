FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/${PN}:"
SRC_URI_append_gsj = " file://00-bmc-usb0.network"
SRC_URI_append_gsj = " file://usb-network.conf"

FILES_${PN}_append_gsj = " ${datadir}/usb-network/usb-network.conf"
FILES_${PN}_append_gsj = " ${sysconfdir_native}/systemd/network/00-bmc-usb0.network"

do_install_append_gsj() {
    install -d ${D}${sysconfdir_native}/systemd/network/
    install -m 0644 ${WORKDIR}/00-bmc-usb0.network \
        ${D}${sysconfdir_native}/systemd/network

    install -d ${D}${datadir}/usb-network
    install -m 0644 -D ${WORKDIR}/usb-network.conf \
        ${D}${datadir}/usb-network
}
