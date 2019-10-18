FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI_remove = "file://BootBlockAndHeader_EB.xml"
SRC_URI_remove = "file://UbootHeader_EB.xml"
SRC_URI_append_olympus-nuvoton += " file://BootBlockAndHeader_olympus.xml"
SRC_URI_append_olympus-nuvoton += " file://UbootHeader_olympus.xml"


do_install_append_olympus-nuvoton() {
	install ${WORKDIR}/BootBlockAndHeader_olympus.xml ${D}${bindir}/BootBlockAndHeader_EB.xml
	install ${WORKDIR}/UbootHeader_olympus.xml ${D}${bindir}/UbootHeader_EB.xml
}

