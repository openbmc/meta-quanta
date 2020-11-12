FILESEXTRAPATHS_prepend_gbs := "${THISDIR}/${PN}:"
SRCREV_gbs = "01a77864f49088bac80474587a123d1f152f2b26"
SRC_URI_append_gbs = " file://0001-x86-power-control-change-some-behaviors-and-add-boot.patch \
                       file://power-config-host0.json \
                       file://chassis-system-reset.service \
                     "

EXTRA_OECMAKE_append_gbs = " -DCHASSIS_SYSTEM_RESET=ON"

do_install_append_gbs() {
    install -d ${D}${datadir}/${PN}
    install -m 0644 ${WORKDIR}/power-config-host0.json ${D}${datadir}/${PN}
}

