
require recipes-core/images/core-image-minimal.bb

IMAGE_FEATURES += "ssh-server-openssh debug-tweaks"

# 128MB filesystem
IMAGE_ROOTFS_SIZE = "131072"

