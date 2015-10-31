
# Need binutils for libiberty.a
do_unpack[depends] += "binutils-native:do_populate_sysroot"

