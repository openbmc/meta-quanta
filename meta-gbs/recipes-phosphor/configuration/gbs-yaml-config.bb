SUMMARY = "YAML configuration for gbs"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit allarch

SRC_URI = " \
    file://gbs-ipmi-fru.yaml \
    file://gbs-ipmi-sensors.yaml \
    "

S = "${WORKDIR}"

do_install() { 
    install -m 0644 -D gbs-ipmi-fru.yaml \
        ${D}${datadir}/${PN}/ipmi-fru-read.yaml
    install -m 0644 -D gbs-ipmi-sensors.yaml \
        ${D}${datadir}/${PN}/ipmi-sensors.yaml
}

FILES_${PN}-dev = " \
    ${datadir}/${PN}/ipmi-fru-read.yaml \
    ${datadir}/${PN}/ipmi-sensors.yaml \
    "
