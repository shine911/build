#!/bin/bash

clear

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
INPUT=
USER=
PASS=
HOST=

# Time of build startup
res1=$(date +%s.%N)

echo "Do you want use FTP upload [Y/n]:"
read INPUT
if ["$INPUT"=="y"]
then
INPUT=Y
else
INPUT=n
fi

if ["$INPUT"=="Y"]
then
echo -e "${bldblu}FTP HOST [Type and ENTER]:${txtrst}"
read HOST
echo -e "${bldblu}FTP USER [Type and ENTER]:${txtrst}"
read USER
echo -e "${bldblu}FTP PASS [Type and ENTER]:${txtrst}"
read PASS
fi

# Sync with latest sources
if [ "$SYNC" == "1" ]
then
echo -e "${bldblu}Reset all local commit${txtrst}"
   repo forall -c "git reset --hard"
   echo -e "${bldblu}Syncing latest sources ${txtrst}"
   repo sync -j"$THREADS"
   echo -e "${bldblu}Starting Patching...${txtrst}"
   ./patch.sh
   echo -e "${bldblu}DONE!${txtrst}"
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
export CCACHE_DIR="`pwd`/../.slimccache"
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# Lunch device
echo -e "${bldblu}Lunching device... ${txtrst}"
lunch "slim_$DEVICE-userdebug"

# Remove previous build info
echo -e "${bldblu}Removing previous build.prop ${txtrst}"
rm $OUT/system/build.prop;

# Start compilation
echo -e "${bldblu}Starting build for $DEVICE ${txtrst}"
schedtool -B -n 1 -e ionice -n 1 make -j$(cat /proc/cpuinfo | grep "^processor" | wc -l) "$@"

# Upload to FTP
cd $OUT
if [ "$INPUT" == "Y" ]
then
. patch/upload.sh
fi

# Get elapsed time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"