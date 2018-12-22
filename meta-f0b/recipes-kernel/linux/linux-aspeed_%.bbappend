FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://f0b.cfg"

do_configure_append() {
    cat ${WORKDIR}/*.cfg >> ${B}/.config
}
