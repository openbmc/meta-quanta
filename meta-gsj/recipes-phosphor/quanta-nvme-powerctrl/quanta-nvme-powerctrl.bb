SUMMARY = "Phosphor OpenBMC Quanta NVME Power Control Service"
DESCRIPTION = "Phosphor OpenBMC Quanta NVME Power Control Daemon."
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${QUANTABASE}/COPYING.apache-2.0;md5=34400b68072d710fecd0a2940a0d1658"

FILESEXTRAPATHS_append := "${THISDIR}/files:"

inherit systemd

DEPENDS += "systemd"
RDEPENDS_${PN} += "libsystemd"
RDEPENDS_${PN} += "bash"

SRC_URI +=  "file://init_once.sh \
             file://nvme_powermanager.sh \
             file://nvme_gpio.service \
             file://nvme_powermanager.service \
            "

do_install () {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/init_once.sh ${D}${sbindir}
    install -m 0755 ${WORKDIR}/nvme_powermanager.sh ${D}${sbindir}/

    install -d ${D}${systemd_unitdir}/system/
    install -m 0644 ${WORKDIR}/nvme_gpio.service ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/nvme_powermanager.service ${D}${systemd_unitdir}/system 
}

SYSTEMD_PACKAGES = "${PN}"
SYSTEMD_SERVICE_${PN} = "nvme_gpio.service nvme_powermanager.service"
