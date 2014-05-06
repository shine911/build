#!/bin/bash

# Colorize and add text parameters
grn=$(tput setaf 2) # green
txtbld=$(tput bold) # Bold
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
txtrst=$(tput sgr0) # Reset

DEVICE="$1"
SYNC="$2"
THREADS="$3"
CLEAN="$4"

# Time of build startup
res1=$(date +%s.%N)

# Sync with latest sources
if [ "$SYNC" == "1" ]
then
#echo -e "${bldblu}Reset all local commit${txtrst}"
#  repo forall -c "git reset --hard"
   echo -e "${bldblu}Syncing latest sources ${txtrst}"
   repo sync -j"$THREADS"
#   echo -e "${bldblu}Starting Patching...${txtrst}"
#   ./patch.sh
#   echo -e "${bldblu}DONE!${txtrst}"
fi

# Clean out folder
if [ "$CLEAN" == "1" ]
then
echo -e "${bldblu}Cleaning up out folder ${txtrst}"
   make clobber;
else
echo -e "${bldblu}Skipping out folder cleanup ${txtrst}"
fi

# Setup environment
echo -e "${bldblu}Setting up build environment ${txtrst}"
. build/envsetup.sh
export USE_CCACHE=1
export CCACHE_DIR="`pwd`/../.ubuntuccache"
prebuilts/misc/linux-x86/ccache/ccache -M 20G

# Lunch device
#echo -e "${bldblu}Lunching device... ${txtrst}"
#lunch "$DEVICE"

# Remove previous build info
echo -e "${bldblu}Removing previous build.prop ${txtrst}"
rm $OUT/system/build.prop;

# Start compilation
echo -e "${bldblu}Starting build for $DEVICE ${txtrst}"
brunch "$DEVICE"

# Upload to FTP
# cd $OUT
#. patch/patches/upload.sh

# Get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"