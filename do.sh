#!/bin/sh
set -e

#default_flavour="tuxy"
default_flavour="minituxy"

# OpenEmbedded
export OEBASE=$(dirname $(readlink -f $0))
# toolchain
export EXTERNAL_TOOLCHAIN="${OEBASE}/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf"
# machine related
export DEFAULTTUNE="cortexa7hf-neon-vfpv4"
export TCMODE="external-linaro"
# local stuff
export PATH="$OEBASE/openembedded-core/scripts:$OEBASE/sources/bitbake/bin:$EXTERNAL_TOOLCHAIN/bin:$PATH"
export CORE_COUNT=$(cat /proc/cpuinfo |grep ^processor|wc -l)
export BB_ENV_EXTRAWHITE="MACHINE DISTRO TCLIBC TCMODE EXTERNAL_TOOLCHAIN DEFAULTTUNE GIT_PROXY_COMMAND http_proxy ftp_proxy https_proxy all_proxy ALL_PROXY no_proxy SSH_AGENT_PID SSH_AUTH_SOCK BB_SRCREV_POLICY SDKMACHINE TARGET_SYS OEBASE CORE_COUNT"

do_usage() {
  echo "USAGE: flavour=tuxy|minituxy $0 init|build|bitbake|flash|mrproper <args>"
  exit 1
}

env_flavour() {

  if [ -z "$flavour" ]; then
    echo "NOTE no 'flavour' environment variable found, defaulting to flavour=$default_flavour"
    flavour=$default_flavour
  fi

  case "$flavour" in
    tuxy)
      export MACHINE="olinuxino-a20"
      export DISTRO="tuxy"
      image_recipe="tuxy-image"
    ;;
    minituxy)
      export MACHINE="olinuxino-a20lime"
      export DISTRO="minituxy"
      image_recipe="tuxy-image"
    ;;
    *)
      echo "ERROR '$flavour' unknown or not set. Please to do at the begining of this file ($0) or as envar (flavour=<flavour> $0)."
      exit 1
    ;;
  esac
  echo "NOTE flavour=$flavour is MACHINE=$MACHINE, DISTRO=$DISTRO, image_recipe=$image_recipe"
}

do_toolchain() {
  gcc_dir="gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabihf"
  gcc_archive="${gcc_dir}.tar.xz"
  gcc_url="http://releases.linaro.org/15.02/components/toolchain/binaries/arm-linux-gnueabihf/$gcc_archive"
  if [ ! -d $gcc_dir ]; then
    if [ ! -d downloads ]; then mkdir downloads; fi
    if [ ! -f downloads/$gcc_archive ]; then
      wget --no-check-certificate --directory-prefix=downloads "$gcc_url"
    fi
    tar -Jxf downloads/$gcc_archive
  fi
}

do_layers() {
  cd sources
  if [ ! -d bitbake ]; then
    git clone --branch 1.26 git://github.com/openembedded/bitbake.git
  fi
  if [ ! -d meta-linaro ]; then
    git clone --branch fido git://git.linaro.org/openembedded/meta-linaro.git
  fi
  if [ ! -d meta-openembedded ]; then
    git clone --branch fido git://github.com/openembedded/meta-openembedded.git
  fi
  if [ ! -d meta-sunxi ]; then
    git clone --branch master git://github.com/linux-sunxi/meta-sunxi.git
  fi
  if [ ! -d openembedded-core ]; then
    git clone --branch fido git://github.com/openembedded/openembedded-core.git
  fi
}

do_init() {
  echo "init..."
  echo "init... toolchain..."
  do_toolchain
  echo "init... layers..."
  do_layers
  echo "init... done"
}

do_build() {
  echo "build $flavour ..."
  time bitbake $image_recipe
  echo "build $flavour ... done"
}

do_bitbake() {
  echo "bitbake $* ..."
  bitbake $*
  echo "bitbake $* ... done"
}

do_flash() {
  echo "flash $flavour ..."

  if [ ! -e /dev/mmcblk0 ]; then
    echo "ERROR /dev/mmcblk0 not found. Please insert a sdcard in MMC slot."
    exit 1
  fi
  sdimg="build/deploy/images/$DISTRO-$MACHINE/$image_recipe-${MACHINE}.sunxi-sdimg"
  if [ ! -e $sdimg ]; then
    echo "ERROR $sdimg not built, must do build-${flavour}."
    exit 1
  fi
  time sudo dd bs=4M oflag=sync if=$sdimg of=/dev/mmcblk0
  sync
  echo "flash $flavour... done"
}

do_mrproper() {
  echo "mrproper..."
  rm -fr ./build ./conf/sanity_info
  echo "mrproper... done"
}

# experiment, does not provide any value yet.
do_graphviz() {
  echo "graphviz..."
  EXTRA_ASSUME_PROVIDED="
pkgconfig-native
virtual/update-alternatives
texinfo-native
virtual/gettext
gettext-native
zlib
libtool-cross
libtool-native
automake-native
autoconf-native
gnu-config-native
virtual/arm-linux-gnueabihf-compilerlibs
virtual/libc
virtual/arm-linux-gnueabihf-gcc"
  bitbake -g --ignore-deps="$EXTRA_ASSUME_PROVIDED" $image_recipe
  dot -Tpng pn-depends.dot > pn-depends.png
  echo "graphviz... done"
}

do_sav() {
  # tar zcf ~/sav/openembedded- date +%Y%m%d-%H%M
  :
}

cd $OEBASE
env_flavour
cmd=$1
if [ ! -z "$cmd" ]; then shift; fi
case "$cmd" in
  init) do_init;;
  build) do_build;;
  bitbake) do_bitbake $*;;
  flash) do_flash;;
  mrproper) do_mrproper;;
  graphviz) do_graphviz;;
  sav) do_sav;;
  *) do_usage;;
esac

