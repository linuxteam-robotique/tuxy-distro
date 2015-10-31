
# Tuxy distro

Minimalist embbeded distribution for robotic usage based on OpenEmbedded and linux-sunxi for Olimex OLinuXino Allwinner SoCs based boards.

## Hardware

For Olimex Olinuxino boards based on Allwinner SoCs with SD card connector. It at been tested on:
- A20-OLinuXino-LIME https://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-LIME/open-source-hardware
- A20-OLinuXino-MICRO https://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-MICRO/open-source-hardware

Note: It should work on most embedded board based on SoC of the AllWinner family without too much work.

## Software

Tuxy distro is based on OpenEmbedded http://www.openembedded.org/ , sunxi layer https://github.com/linux-sunxi/meta-sunxi and the work done by the linux-sunxi community http://linux-sunxi.org .

Tuxy distro is a minimalist distibution:
- Small image (~core-image-minimal)
- Boot speed slightly optimized to boot in 6 seconds (mostly u-boot tuning)

2 images are available:
- tuxy-image: minimal distro with openssh server, 20 MB used on 128 MB rootfs
- tuxy-image-dev: minimal distro with openssh server and development tools (gdb, gdbserver, cpp, gcc, make, vim), 90 MB used on 256 MB rootfs

## Build

Availables build <flavour>:
- tuxy: tuxy-image-dev build for A20-OLinuXino-MICRO), eth0 IP address 192.168.0.99
- minituxy: tuxy-image-dev build for A20-OLinuXino-LIME), eth0 IP address 192.168.0.99

Build instruction:
  $ git clone git://github.com/linuxteam-robotique/tuxy-distro.git
  $ cd tuxy-distro
  $ flavour=<flavour> ./do.sh init
  $ flavour=<flavour> ./do.sh build
  insert an SD card in MMC card reader, do NOT mount it
  # flavour=<flavour> ./do.sh flash
  insert SD card into SD card connector of the board and power it up... wait 6 seconds... booted!

## Prebuild SD card images

Flash image to SD card located in SD card reader:
  $ dd bs=4M oflag=sync if=<image> of=/dev/mmcblk0

## TODO

- wireless

