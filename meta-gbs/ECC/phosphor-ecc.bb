LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PR = "r1"
S = "${WORKDIR}/git"

inherit autotools pkgconfig
inherit obmc-phosphor-dbus-service obmc-phosphor-systemd

HASHSTYLE = "gnu"
CXXFLAGS += "-std=c++17"

DEPENDS += "sdbusplus"
DEPENDS += "phosphor-dbus-interfaces"
DEPENDS += "sdeventplus"
DEPENDS += "phosphor-logging"
DEPENDS += "sdbusplus-native"
DEPENDS += "autoconf-archive-native"
DEPENDS += "phosphor-sel-logger"

SRC_URI = "git://github.com/quanta-bmc/phosphor-ecc.git;protocol=git"
SRCREV := "1a8c5b09c6400c1fb0df8099e273ecc590140d6d"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
DBUS_SERVICE_${PN}_append = " phosphor-ecc.service"
