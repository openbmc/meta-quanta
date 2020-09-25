DEPENDS += "bmcweb"
DEPENDS += "phosphor-ipmi-host"
RDEPENDS_${PN} += "bmcweb"
RDEPENDS_${PN} += "phosphor-ipmi-host"
USERADD_PARAM_${PN} = "-m -N -u 1000 -g 100 -s /bin/nologin \
                       -p '\$1\$UGMqyqdG\$FZiylVFmRRfl9Z0Ue8G7e/' \
                       -G 'web,redfish,priv-admin' Megapede; " 
GROUPMEMS_PARAM_${PN} = "-g priv-admin -a root; "
GROUPMEMS_PARAM_${PN} += "-g ipmi -a root; "
