SUMMARY = "Add default CA"
DESCRIPTION = "Add default CA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://certs/authority/" 

FILES_${PN} = "${sysconfdir}/ssl/certs/authority/*"

do_install(){
    install -d ${D}${sysconfdir}/ssl/certs/authority
    install -m 0644 -D ${WORKDIR}/certs/authority/* \
                       ${D}${sysconfdir}/ssl/certs/authority
}
