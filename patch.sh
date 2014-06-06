echo -e $CL_BLU"Cherrypicking ART Patch"$CL_RST
cd art
git fetch https://github.com/JustArchi/android_art android-4.4
git cherry-pick 8354d2dc9d260ca67dbdf32e123bd4da62b8a68d
cd ../
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_av"$CL_RST
cd frameworks/av
git fetch https://github.com/shine911/frameworks_av kk4.4
git cherry-pick 7bcfe33b327ecb0f83cc42a2e72ba77a9cf8205d
cd ..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_native"$CL_RST
cd native
git fetch https://github.com/shine911/frameworks_native kk4.4
git cherry-pick f8135f6b1d09a9a68f44558d9404692a4fee9f64
echo -e $CL_BLU"Cherrypicking Legacy sensors"$CL_RST
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/11/59311/1
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_base"$CL_RST
cp patch/patches/frameworks/base/core/jni/android_media_AudioRecord.cpp frameworks/base/core/jni/android_media_AudioRecord.cpp
echo -e $CL_BLU"Cherrypicking Core Patch - OMX, reboot/shutdown fix and samsung: allow lpm from command line"$CL_RST
cp patch/patches/system/core/init/init.c system/core/init/init.c
cd system/core
git fetch https://github.com/shine911/android_system_core kk4.4
git cherry-pick 2b0023e4f82d1204fd21da10bd94bb3b79179366
git cherry-pick d200432d947cbe40b8aacf7b284d7d62d99c1fdb
cd ..
echo -e $CL_BLU"Cherrypicking vold patch to allow switching storages"$CL_RST
cd vold
git fetch https://github.com/shine911/android_system_vold kk4.4
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking vibrator fix"$CL_RST
cd hardware/libhardware_legacy
git fetch https://github.com/TeamCanjica/android_hardware_libhardware_legacy cm-11.0
git cherry-pick 9c2250d32a1eda9afe3b5cefe3306104148aa532
cd ../..
echo -e $CL_BLU"Cherrypicking Camera fix"$CL_RST
cd packages/apps/Camera2
git fetch https://github.com/CyanogenMod/android_packages_apps_Camera2 cm-11.0
git cherry-pick 42067bbce2203088e09039169b0262691dd07e97
cd ../../..
echo -e $CL_BLU"Cherrypicking Low-incall Volume Fix"$CL_RST
cd packages/services/Telephony
git fetch https://github.com/shine911/packages_services_Telephony kk4.4
git cherry-pick 94d43efa096783d3df4200fcc5ebec1044f6f03c
cd ../../..