
FILESEXTRAPATHS_append := "${THISDIR}/files:"

do_install_prepend() {
    if [ ! -z "${ETH0_IP_ADDR}" ]; then
      # note: it is ok to use ip address in sed search pattern here as
      # interfaces file is owned by this recipe
      sed -i ${WORKDIR}/interfaces -e 's/address 192.168.0.99/address ${ETH0_IP_ADDR}/'
    fi
}
