FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_runbmc-nuvoton = " file://0001-bmcweb-add-clear-event-logs-function.patch"
