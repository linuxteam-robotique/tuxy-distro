
do_compile_prepend() {
  # disable USB in u-boot as not used to speed up boot time (3 seconds speedup with 2 connected USB devices)
  sed -i ${S}/configs/A20-OLinuXino-Lime_defconfig -e 's/CONFIG_USB_EHCI_HCD=y/# CONFIG_USB_EHCI_HCD is not set/'

  # disable SATA in sunxi config in u-boot as not used to speed up boot time (~0.5 seconds speedup with no SATA device)
  sed -i ${S}/include/configs/sunxi-common.h -e 's/#ifdef CONFIG_AHCI/#ifdef CONFIG_AHCI_disabled/'

  # set boot delay to 0 (2 seconds per default)
  echo "#define CONFIG_BOOTDELAY 0" >> ${S}/include/configs/sunxi-common.h
}
