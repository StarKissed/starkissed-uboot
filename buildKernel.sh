#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

if cat /etc/issue | grep Ubuntu; then

HANDLE=twistedumbrella
TOOLCHAIN_PREFIX=~/android/android-toolchain-eabi/bin
KERNELSPEC=~/android/starkissed-uboot-tuna
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
KERNELSPEC=/Volumes/android/starkissed-uboot-tuna
BUILDSTRUCT=darwin
PUNCHCARD=`date "+%m-%d-%Y_%H.%M"`
ANDROIDREPO=/Users/TwistedZero/Public/Dropbox/TwistedServer/Playground

fi

BOOTSCSRC=$KERNELSPEC/bootscripts
MKBOOTIMG=$KERNELSPEC/buildImg
KERNELREPO=$ANDROIDREPO/kernels
GOOSERVER=loungekatt@upload.goo.im:public_html

if [ $1 == "y" ]; then

BOOTOUTPT=$KERNELSPEC/dualPack
BOOTSCRPT=$BOOTOUTPT/data/uboot

zipfile=$HANDLE"_StarKissed-JB42X-uPack.zip"
KENRELZIP="StarKissed-JBXXX_$PUNCHCARD-uPack.zip"
KERNELDIR="dualPack"

else

BOOTOUTPT=$KERNELSPEC/dualBoot
BOOTSCRPT=$KERNELSPEC/bootscripts

zipfile=$HANDLE"_StarKissed-JB42X-uBoot.zip"
KENRELZIP="StarKissed-JBXXX_$PUNCHCARD-uBoot.zip"
KERNELDIR="dualBoot"

fi

CPU_JOB_NUM=8

cd $KERNELSPEC

export PATH=$TOOLCHAIN_PREFIX:$PATH
export ARCH=arm
export CROSS_COMPILE=arm-eabi-

make clean
make distclean

make omap4_tuna_config
make -j$CPU_JOB_NUM omap4_tuna

$MKBOOTIMG/$BUILDSTRUCT/./mkbootimg --kernel u-boot.bin --ramdisk /dev/null -o $BOOTOUTPT/u-boot.img

tools/./mkimage -A arm -O linux -T script -C none -a 0x84000000 -e 0x84000000 -n android -d $BOOTSCSRC/internal.src $BOOTSCRPT/internal.src.uimg

tools/./mkimage -A arm -O linux -T script -C none -a 0x84000000 -e 0x84000000 -n android -d $BOOTSCSRC/external.src $BOOTSCRPT/external.src.uimg

if [ -e $BOOTOUTPT/u-boot.img ]; then

cd $KERNELDIR
rm *.zip
zip -r $zipfile *
cd ../
cp -R $KERNELSPEC/$KERNELDIR/$zipfile $KERNELREPO/$zipfile

if [ $1 != "y" ]; then

cp -R $BOOTOUTPT/u-boot.img $KERNELREPO/images/u-boot.img
scp -P 2222 $BOOTOUTPT/u-boot.img $GOOSERVER/uBootRepo
cp -R $BOOTSCRPT/internal.src.uimg $KERNELREPO/images/internal.src.uimg
scp -P 2222 $BOOTSCRPT/internal.src.uimg $GOOSERVER/uBootRepo
cp -R $BOOTSCRPT/external.src.uimg $KERNELREPO/images/external.src.uimg
scp -P 2222 $BOOTSCRPT/external.src.uimg $GOOSERVER/uBootRepo

fi

cp -R $KERNELREPO/$zipfile ~/.goo/$KENRELZIP
scp -P 2222 ~/.goo/$KENRELZIP  $GOOSERVER/starkissed
rm -r ~/.goo/*

fi