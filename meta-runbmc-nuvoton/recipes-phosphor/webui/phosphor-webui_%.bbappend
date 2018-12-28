FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRCREV = "0f2f981e3218a57f89995aa6cb6b684b2ec0ba8f"

SRC_URI += "file://0001-Implement-KVM-in-webui.patch"
SRC_URI += "file://0002-Implement-VM-in-webui.patch"

do_compile () {

    cd ${S}
    rm -rf node_modules
    npm --loglevel info --proxy=${HTTP_PROXY} --https-proxy=${HTTPS_PROXY} install
    sed -i -e 's/new WebSocket(uri, protocols)/new WebSocket(uri)/g' node_modules/@novnc/novnc/core/websock.js
    npm run-script build
}


