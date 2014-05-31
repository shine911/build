echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_av"$CL_RST
cd frameworks/av
git fetch https://github.com/shine911/AOSPA_frameworks_av kitkat
git cherry-pick aee628ab06453665df02de409d762f618e59dedd
cd ..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_native"$CL_RST
cd native
git fetch https://github.com/shine911/AOSPA_frameworks_native kitkat
git cherry-pick c938324823f195a3214681184eb9f34c406e9c74

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
git cherry-pick 482266312537d3fb96e762c99d49525508124c25
git cherry-pick f669e2930b2168180b1316f407b33ba9b5523581
cd ..
echo -e $CL_BLU"Cherrypicking vold patch to allow switching storages"$CL_RST
cd vold
git fetch https://github.com/shine911/android_system_vold kk4.4
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking fixes build"$CL_RST
cd device/samsung/u8500-common
git fetch https://github.com/shine911/android_device_samsung_u8500-common slimkat
git cherry-pick cd75100ef6fe967608994932c56825030c4f77cf
cd ../../../
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