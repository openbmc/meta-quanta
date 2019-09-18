FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


NAMES = " \
        i2c@82000/tmp421@4c \
        i2c@82000/power-supply@58 \
        i2c@86000/tps53679@60 \
        i2c@86000/tps53659@62 \
        i2c@86000/tps53659@64 \
        i2c@86000/tps53679@70 \
        i2c@86000/tps53659@72 \
        i2c@86000/tps53659@74 \
        i2c@86000/tps53622@67 \
        i2c@86000/tps53622@77 \
        i2c@86000/ina219@40 \
        i2c@86000/ina219@41 \
        i2c@86000/ina219@44 \
        i2c@86000/ina219@45 \
        i2c@87000/tmp421@4c \
        i2c@88000/adm1278@11 \
        i2c@8d000/tmp75@4a  \
        "

ITEMSFMT = "ahb/apb/{0}.conf"

ITEMS += "${@compose_list(d, 'ITEMSFMT', 'NAMES')}"

ENVS = "obmc/hwmon/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "${@compose_list(d, 'ENVS', 'ITEMS')}"

# Fan sensors
FITEMS = "pwm-fan-controller@103000.conf"
FENVS = "obmc/hwmon/ahb/apb/{0}"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "${@compose_list(d, 'FENVS', 'FITEMS')}"

# ADC
ADC_ITEMS = "adc@c000.conf"
SYSTEMD_ENVIRONMENT_FILE_${PN} += "${@compose_list(d, 'FENVS', 'ADC_ITEMS')}"
