BASEDIR=$(pwd)
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
cd ..
echo -e $CL_BLU"Cherrypicking Ok google, workaround API check Patch and SystemUI Crash reduce patch - android_frameworks_base"$CL_RST
cd base
git apply $BASEDIR/patch/patches/frameworks_base.patch
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/34/63034/2
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking Core Patch - OMX, reboot/shutdown fix"$CL_RST
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
echo -e $CL_BLU"Cherrypicking clang optimisation suppression patches"$CL_RST
cd external/clang
git fetch https://github.com/zwliew/android_external_clang cm-11.0
git cherry-pick bb0a1a5f007dc6e6f111c3a726977c4cce256bc5
git cherry-pick 085466671e3c0483466de009bbc81fd31505f6e6
cd ..
echo -e $CL_BLU"Cherrypicking chromium_org don't make error build"$CL_RST
cd chromium_org
git fetch https://github.com/shine911/android_external_chromium_org cm-11.0
git cherry-pick FETCH_HEAD
cd ..
echo -e $CL_BLU"Cherrypicking exfat compilation fix"$CL_RST
cd fuse
git fetch https://github.com/SlimSaber/android_external_fuse kk4.4
git cherry-pick f3736cb1104f72ee1f1322a4eea79e960bee0cd6
cd ..
cd exfat
git fetch https://github.com/SlimSaber/android_external_exfat kk4.4
git cherry-pick 0cbb04e3fd9a254dbddf440355949383a9a00976
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