FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI_append = " file://certs/authority/*"

DEPENDS += "openssl-native"

do_compile_append(){
    mkdir -p ${WORKDIR}/certs/https
    openssl req -x509 -newkey rsa:4096 -sha256 -nodes \
    -keyout ${WORKDIR}/certs/https/key.pem \
    -out ${WORKDIR}/certs/https/server.pem \
    -days 3650 \
    -subj "/C=US/ST=California/L=Mountain View/O=Google/OU=Platforms/CN=${MACHINE_ARCH}"

    cat ${WORKDIR}/certs/https/key.pem >> ${WORKDIR}/certs/https/server.pem
}

do_install_append () {
    install -d ${D}${sysconfdir}/ssl/certs/authority
    install -m 0644 -D ${WORKDIR}/certs/authority/* \
                       ${D}${sysconfdir}/ssl/certs/authority

    install -d ${D}${sysconfdir}/ssl/certs/https
    install -m 0644 ${WORKDIR}/certs/https/server.pem \
                    ${D}${sysconfdir}/ssl/certs/https
}

