#!/bin/bash

clear
cd kernel

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTDIR="$BASEDIR/out"
INITRAMFSDIR="$BASEDIR/usr/STE_initramfs.list"
TOOLCHAIN="/home/quihuynh/kernel/prebuilts/gcc/linux-x86/arm/arm-eabi-4.9/bin/arm-eabi-"
SYNC="$1"
CLEAN="$2"
ARCH=arm
CROSS_COMPILE=$TOOLCHAIN
# Time of build startup
res1=$(date +%s.%N)

# Sync with latest sources
if [ "$SYNC" == "1" ]
then
cd ../
   repo sync -f
cd kernel
fi

# Clean out folder
if [ "$CLEAN" == "1" ]
then
echo -e "${bldblu}Cleaning up out folder ${txtrst}"
   make clobber;
else
echo -e "${bldblu}Skipping out folder cleanup ${txtrst}"
fi

echo -e "\n\n Configuring I8160 Kernel...\n\n"
make cyanogenmod_i8160_defconfig ARCH=arm CROSS_COMPILE=$TOOLCHAIN
echo -e "\n\n Compiling I8160 Kernel and Modules... \n\n"
make -j4 ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE=$INITRAMFSDIR

echo -e "\n\n Finish kernel... \n\n"
mkdir -p $OUTDIR/system/lib/modules/
find . -name "*.ko" -exec cp {} ../$OUTDIR/system/lib/modules \;
cp arch/arm/boot/zImage $OUTDIR/boot.img

# Get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"