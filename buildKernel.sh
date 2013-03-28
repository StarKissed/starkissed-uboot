#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

if cat /etc/issue | grep Ubuntu; then

HANDLE=twistedumbrella
TOOLCHAIN_PREFIX=~/android/android-toolchain-eabi/bin
KERNELSPEC=~/android/uboot-tuna
BUILDSTRUCT=linux
ANDROIDREPO=~/Dropbox/TwistedServer/Playground

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

HANDLE=TwistedZero
TOOLCHAIN_PREFIX=/Volumes/android/android-toolchain-eabi/bin
KERNELSPEC=/Volumes/android/uboot-tuna
BUILDSTRUCT=darwin
PUNCHCARD=`date "+%m-%d-%Y_%H.%M"`
ANDROIDREPO=/Users/TwistedZero/Public/Dropbox/TwistedServer/Playground

fi

MKBOOTIMG=$KERNELSPEC/buildImg

GOOSERVER=loungekatt@upload.goo.im:public_html

CPU_JOB_NUM=8

cd $KERNELSPEC

export PATH=$TOOLCHAIN_PREFIX:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-eabi-

make clean
make distclean

make omap4_tuna_config
make -j$CPU_JOB_NUM omap4_tuna

$MKBOOTIMG/$BUILDSTRUCT/./mkbootimg --kernel u-boot.bin --ramdisk /dev/null -o $MKBOOTIMG/u-boot.img

if [ -e $MKBOOTIMG/u-boot.img ]; then
scp -P 2222 $MKBOOTIMG/u-boot.img  $GOOSERVER/uBootRepo
rm -r $MKBOOTIMG/u-boot.img
fi