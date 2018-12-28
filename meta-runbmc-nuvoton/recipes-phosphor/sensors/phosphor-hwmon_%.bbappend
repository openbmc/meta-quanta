FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


NAMES = " \
        i2c-bus@82000/tmp421@4c \
        i2c-bus@87000/tmp421@4c \
        i2c-bus@8d000/tmp75@4a  \
        "
ITEMSFMT = "ahb/apb/{0}.conf"

ITEMS += "${@compose_list(d, 'ITEMSFMT', 'NAMES')}"

ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "${@compose_list(d, 'ENVS', 'ITEMS')}"

# Fan sensors
FITEMS = "pwm-fan-controller@103000.conf"
FENVS = "obmc/hwmon/ahb/apb/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "${@compose_list(d, 'FENVS', 'FITEMS')}"
