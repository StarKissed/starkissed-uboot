#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

if cat /etc/issue | grep Ubuntu; then

TOOLCHAIN_PREFIX=~/android/android-toolchain-eabi/bin
KERNELSPEC=~/android/uboot-tuna
MKBOOTIMG=$KERNELSPEC/buildImg
CONSTRUCT=linux

cd $KERNELSPEC/mkboot

gcc -o mkbootfs mkbootfs.c

gcc -c rsa.c
gcc -c sha.c
gcc -c mkbootimg.c
gcc rsa.o sha.o mkbootimg.o -o mkbootimg
rm *.o

cp -R mkbootfs $MKBOOTIMG
cp -R mkbootimg $MKBOOTIMG

else

TOOLCHAIN_PREFIX=/Volumes/android/android-toolchain-eabi/bin
KERNELSPEC=/Volumes/android/uboot-tuna
MKBOOTIMG=$KERNELSPEC/buildImg
CONSTRUCT=darwin

fi

export PATH=$TOOLCHAIN_PREFIX:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-eabi-

make clean
make distclean

make omap4_tuna_config
make -j8 omap4_tuna

$MKBOOTIMG/$CONSTRUCT/./mkbootimg --kernel u-boot.bin --ramdisk /dev/null -o dualBoot/u-boot.img

$MKBOOTIMG/$CONSTRUCT/./mkbootfs $MKBOOTIMG/ramdisk | gzip > $MKBOOTIMG/newramdisk.cpio.gz
$MKBOOTIMG/$CONSTRUCT/./mkbootimg --cmdline 'no_console_suspend=1' --kernel $MKBOOTIMG/zImage --ramdisk $MKBOOTIMG/newramdisk.cpio.gz -o dualBoot/system/boot/2nd.uimg

cd dualBoot
rm *.zip
zip -r "u-bootTuna.zip" *