#!/bin/bash

# Copyright (C) 2011 Twisted Playground

# This script is designed by Twisted Playground for use on MacOSX 10.7 but can be modified for other distributions of Mac and Linux

if cat /etc/issue | grep Ubuntu; then

KERNELSPEC=~/android/starkissed-uboot
BUILDSTRUCT=linux

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

KERNELSPEC=/Volumes/android/starkissed-uboot
BUILDSTRUCT=darwin

fi

MKBOOTIMG=$KERNELSPEC/buildImg/$BUILDSTRUCT

cd $KERNELSPEC/ubuntuBoot

$MKBOOTIMG/./mkbootfs ramdisk | gzip > ramdisk-new.gz
$MKBOOTIMG/./mkbootimg --cmdline "no_console_suspend=1 console=null mms_ts.panel_id=18" --kernel zImage --ramdisk ramdisk-new.gz -o ubuntu.img