FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " file://bmcweb_persistent_data.json"

do_install_append () {
    install -d ${D}${ROOT_HOME}
    install -m 0640 ${WORKDIR}/bmcweb_persistent_data.json ${D}${ROOT_HOME}
}

FILES_${PN} += "${ROOT_HOME}/bmcweb_persistent_data.json"