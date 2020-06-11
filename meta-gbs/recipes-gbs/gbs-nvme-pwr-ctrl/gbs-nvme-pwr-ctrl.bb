SUMMARY = "NVMe Drives Power Control"
DESCRIPTION = "Daemon to monitor and control the power of NVMe drives"
PR = "r1"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit meson pkgconfig
inherit systemd

DEPENDS += "sdbusplus"
DEPENDS += "boost"
DEPENDS += "libgpiod"

SRC_URI = "git://github.com/quanta-bmc/nvme-power-control;protocol=git"
SRCREV := "0fbb081e81977b7d6ca93d7253ee2e2934d08ec2"

S = "${WORKDIR}/git"

SYSTEMD_SERVICE_${PN} = "xyz.openbmc_project.Control.Nvme.Power.service"
