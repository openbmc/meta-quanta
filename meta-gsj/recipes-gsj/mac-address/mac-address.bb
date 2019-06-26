SRC_URI_gsj = "git://github.com/quanta-bmc/mac-address.git;protocol=git"
SRCREV_gsj = "${AUTOREV}"

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${QUANTABASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

inherit autotools pkgconfig
inherit systemd

FILESEXTRAPATHS_prepend_gsj := "${THISDIR}/files:"
SRC_URI_append_gsj = " file://mac-address.service"

HASHSTYLE = "gnu"

DEPENDS += "systemd"
DEPENDS += "autoconf-archive-native"

S = "${WORKDIR}/git"
CXXFLAGS += "-std=c++17"

do_install_append_gsj() {
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/mac-address.service \
        ${D}${systemd_unitdir}/system
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} += "mac-address.service"