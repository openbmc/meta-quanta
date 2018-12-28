LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

inherit npcm7xx-image

do_install[depends] += "npcm7xx-igps-native:do_populate_sysroot"

SRC_URI = "git://github.com/nuvoton-israel/sign-it.git;"
SRC_URI[md5sum] = "456465"

SRCREV = "74b3fea803b0cdb194ffe9c237e03194620c1ee3"

S = "${WORKDIR}/git"

do_install () {
	install deliverables/linux/release/signit ${IGPS_IMAGE_GENERATION_DIR}/signit
}

inherit native
