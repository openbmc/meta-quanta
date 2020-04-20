LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://github.com/quanta-bmc/mac-address.git;protocol=git"
SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"
SRC_URI_append = " file://mac-address.service"
SRC_URI_append = " file://config.txt"

inherit autotools pkgconfig systemd

DEPENDS += "autoconf-archive-native"

S = "${WORKDIR}/git"
CXXFLAGS += "-std=c++17"

FILES_${PN} += "${bindir}/mac-address"
FILES_${PN} += "${datadir}/mac-address/config.txt"

do_install_append() {
    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/mac-address.service \
        ${D}${systemd_unitdir}/system

    install -d ${D}${datadir}/mac-address
    install -m 0644 -D ${WORKDIR}/config.txt \
        ${D}${datadir}/mac-address/config.txt
}

SYSTEMD_SERVICE_${PN} = "mac-address.service"
