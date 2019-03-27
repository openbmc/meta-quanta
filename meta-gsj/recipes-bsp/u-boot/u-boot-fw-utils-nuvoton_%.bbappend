FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
# SRCREV = "457e879dd929e01f577ec2184670e1bedd27c69d"

SRC_URI += "file://fw_env.config"

do_install_append () {
	install -m 644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}
