
require tuxy-image.inc

IMAGE_FEATURES += "tools-debug eclipse-debug"
IMAGE_INSTALL += "sunxi-tools binutils binutils-symlinks cpp cpp-symlinks gcc gcc-symlinks make procps vim"

# 256MB filesystem
IMAGE_ROOTFS_SIZE = "262144"

