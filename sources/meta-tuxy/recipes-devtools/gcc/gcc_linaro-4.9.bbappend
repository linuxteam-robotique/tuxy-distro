
do_install_prepend() {
    mkdir -p ${STAGING_LIBDIR_NATIVE}/${TARGET_SYS}/gcc/${TARGET_SYS}/${BINV}/include
    cp ${EXTERNAL_TOOLCHAIN}/arm-linux-gnueabihf/libc/usr/lib/include/unwind.h ${STAGING_LIBDIR_NATIVE}/${TARGET_SYS}/gcc/${TARGET_SYS}/${BINV}/include/
}

