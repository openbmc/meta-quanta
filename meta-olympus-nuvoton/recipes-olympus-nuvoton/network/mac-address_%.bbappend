FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://config.txt"

FILES_${PN}_append = " ${datadir}/mac-address/config.txt"

do_install_append() {
    install -d ${D}${datadir}/mac-address
    install -m 0644 -D ${WORKDIR}/config.txt \
        ${D}${datadir}/mac-address/config.txt
}
