
require recipes-core/images/core-image-minimal.bb

IMAGE_FEATURES += "ssh-server-openssh debug-tweaks"

tuxy_rootfs_update() {
    if [ ! -z "${ETH0_IP_ADDR}" ]; then
      # note: interfaces is owned by init-ifupdown_1.%.bbappend and updated here
      sed -i ${IMAGE_ROOTFS}/${sysconfdir}/network/interfaces -e 's/address 192.168.0.99/address ${ETH0_IP_ADDR}/'
    fi
}

IMAGE_PREPROCESS_COMMAND += "tuxy_rootfs_update; "

