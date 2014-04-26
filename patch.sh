echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_av"$CL_RST
cd frameworks/av
git fetch https://github.com/shine911/AOSPA_frameworks_av kitkat
git cherry-pick 3234c927bfc388a55cd9e09cee36f3a3eb63fe1f
cd ..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_native"$CL_RST
cd native
git fetch https://github.com/shine911/AOSPA_frameworks_native kitkat
git cherry-pick 083373c8ee1257997320dc2c9c0d041547a58d77
git cherry-pick 125757e88966464fd1984818ff7666ac1cee9fb2

echo -e $CL_BLU"Cherrypicking Legacy sensors"$CL_RST
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/11/59311/1
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_base"$CL_RST
cp patch/patches/frameworks/base/core/jni/android_media_AudioRecord.cpp frameworks/base/core/jni/android_media_AudioRecord.cpp
echo -e $CL_BLU"Cherrypicking Core Patch - OMX, reboot/shutdown fix and samsung: allow lpm from command line"$CL_RST
cp patch/patches/system/core/init/init.c system/core/init/init.c
cd system/core
git fetch https://github.com/shine911/AOSPA_system_core kitkat
git cherry-pick f39215e8ae4166cec8b02593b6e06b523d0e561c
git cherry-pick 5e4096e52d2f3941006bf530038a147f561a38b4
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
echo -e $CL_BLU"Cherrypicking Low-incall Volume Fix"$CL_RST
cd packages/services/Telephony
git fetch https://github.com/shine911/packages_services_Telephony kk4.4
git cherry-pick 94d43efa096783d3df4200fcc5ebec1044f6f03c
cd ../../..