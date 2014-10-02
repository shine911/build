#!/bin/bash

clear

# Colorize and add text parameters
grn=$(tput setaf 2) # green
txtbld=$(tput bold) # Bold
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
txtrst=$(tput sgr0) # Reset

DEVICE="$1"

# Time of build startup
res1=$(date +%s.%N)

# Setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh
export USE_CCACHE=1
export CCACHE_DIR="`pwd`/../.kkccache"
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# Lunch device
echo -e "${bldblu}Lunching device... ${txtrst}"
lunch "pa_$DEVICE-userdebug"

# Remove previous build info
echo -e "${bldblu}Removing previous build.prop ${txtrst}"
rm $OUT/system/build.prop;

# Start compilation
echo -e "${bldblu}Starting build for $DEVICE ${txtrst}"
./rom-build.sh $DEVICE

# Get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"
    exit 0
esac

# Get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"