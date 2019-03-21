SRCREV = "bfe55a1f7ca6388662cf9613d08ebb5266cd82f8"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
# Replace the default whitelist and apply to all channels for GSJ board.
SRC_URI += " file://0001-fixed-whitelist-for-all-channels.patch"
SRC_URI += " file://gsj-ipmid-whitelist.conf"

WHITELIST_CONF_remove = " ${S}/host-ipmid-whitelist.conf"
WHITELIST_CONF_append = " ${WORKDIR}/gsj-ipmid-whitelist.conf"
