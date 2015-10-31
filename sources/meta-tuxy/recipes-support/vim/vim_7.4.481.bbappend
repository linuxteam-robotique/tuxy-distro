
SRC_URI[sha256sum] = "0ddbdf9937f159d34d2684b25678eedcce79616e6e9c280f36ad5af2e9250814"
SRC_URI[md5sum] = "d6986d90f8d06036f91c4b8088c67489"

SRC_URI = "https://github.com/vim/vim/archive/v${PV}.tar.gz \
           file://disable_acl_header_check.patch;patchdir=.. \
           file://vim-add-knob-whether-elf.h-are-checked.patch;patchdir=.. \
"

S = "${WORKDIR}/${BPN}-${PV}/src"

