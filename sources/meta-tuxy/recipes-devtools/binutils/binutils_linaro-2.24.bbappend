
EXTRA_OECONF_class-native = "--disable-werror"


do_install_append_class-native() {
	install -d ${D}${libdir}
	#install -m 644 ${S}/build.x86_64-linux.x86_64-linux/libiberty/libiberty.a ${D}${libdir}/
	install -m 644 ${B}/libiberty/libiberty.a ${D}${libdir}/
}

