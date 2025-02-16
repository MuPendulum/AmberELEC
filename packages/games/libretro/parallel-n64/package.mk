# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2019-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="parallel-n64"
PKG_VERSION="28c4572c9a09447b3bf5ed5fbd3594a558bc210d"
PKG_SHA256="03ebfd3b27f8d6d2846d180c2dba6ae5dd36f1f1ebea79db8c41817525ce38d2"
PKG_REV="2"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/parallel-n64"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain $OPENGLES"
PKG_SECTION="libretro"
PKG_SHORTDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_LONGDESC="Optimized/rewritten Nintendo 64 emulator made specifically for Libretro. Originally based on Mupen64 Plus."
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="-lto"

if [[ "$ARCH" == "arm" ]]; then
	PKG_MAKE_OPTS_TARGET=" platform=${PROJECT}"
	
	if [[ "${DEVICE}" =~ RG351 ]]; then
		PKG_MAKE_OPTS_TARGET=" platform=Odroidgoa"
	fi
else
	PKG_MAKE_OPTS_TARGET=" platform=emuelec64-armv8"
	
fi

pre_configure_target() {
  sed -i 's/"GFX Plugin; auto|glide64|gln64|rice/"GFX Plugin; rice|auto|glide64|gln64/g' $PKG_BUILD/libretro/libretro.c
  #sed -i 's/"Resolution (restart); 320x240|640x480|960x720/"Resolution (restart); 640x480|320x240|960x720/g' $PKG_BUILD/libretro/libretro.c
  sed -i 's/"Framerate (restart); original|fullspeed"/"Framerate (restart); fullspeed|original"/g' $PKG_BUILD/libretro/libretro.c
  sed -i 's/"GFX Accuracy (restart); veryhigh|high|medium|low"/"GFX Accuracy (restart); low|veryhigh|high|medium"/g' $PKG_BUILD/libretro/libretro.c
  sed -i 's/"(Glide64) Texture Filtering; automatic|N64 3-point|bilinear|nearest"/"(Glide64) Texture Filtering; nearest|automatic|N64 3-point|bilinear"/g' $PKG_BUILD/libretro/libretro.c
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  if [[ "$DEVICE" =~ RG351 ]] && [[ "$ARCH" == "aarch64" ]]
  then
    cp -vP $PKG_BUILD/../../build.${DISTRO}-${DEVICE}.arm/parallel-n64-*/.install_pkg/usr/lib/libretro/parallel_n64_libretro.so ${INSTALL}/usr/lib/libretro/
  else
    cp parallel_n64_libretro.so $INSTALL/usr/lib/libretro/
  fi
}
