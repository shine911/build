echo -e $CL_BLU"Cherrypicking Oliver patches - android_frameworks_av"$CL_RST
cd frameworks/av
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_av refs/changes/21/46421/3
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking Oliver patches - android_system_core"$CL_RST
cd system/core
git fetch http://review.cyanogenmod.org/CyanogenMod/android_system_core refs/changes/32/45032/3
git cherry-pick FETCH_HEAD
cd ../..