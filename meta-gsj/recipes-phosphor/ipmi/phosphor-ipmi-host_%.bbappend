SRC_URI := "git://github.com/quanta-bmc/phosphor-host-ipmid.git"
SRCREV := "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " file://gsj-ipmid-whitelist.conf"
SRC_URI += " file://merge_yamls.py"

WHITELIST_CONF_remove = " ${S}/host-ipmid-whitelist.conf"
WHITELIST_CONF_append = " ${WORKDIR}/gsj-ipmid-whitelist.conf"

EXTRA_OECONF_append = "--with-journal-sel \
                       SENSOR_YAML_GEN=${STAGING_DIR_NATIVE}${sensor_datadir}/sensor.yaml \
                      "
                      