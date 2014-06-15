echo -e $CL_BLU"Cherrypicking JustArchi's ArchiDroid Optimizations V3"$CL_RST
cd build
git fetch https://github.com/shine911/aospa_build kitkat
git cherry-pick 156503b55996ea595f6f5999f249bebae8a187fc
cd ..
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
echo -e $CL_BLU"Cherrypicking Ok Google Patch and patch to reduce SystemUI crashes and freezes - android_frameworks_base"$CL_RST
cp patch/patches/frameworks/base/core/jni/android_media_AudioRecord.cpp frameworks/base/core/jni/android_media_AudioRecord.cpp
cd frameworks/base
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/34/63034/2
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking Core Patch - OMX, reboot/shutdown fix"$CL_RST
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
echo -e $CL_BLU"Cherrypicking clang optimisation suppression patches"$CL_RST
cd external/clang
git fetch https://github.com/zwliew/android_external_clang cm-11.0
git cherry-pick bb0a1a5f007dc6e6f111c3a726977c4cce256bc5
git cherry-pick 085466671e3c0483466de009bbc81fd31505f6e6
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
echo -e $CL_BLU"Cherrypicking from my device common tree"$CL_RST
cd device/samsung/u8500-common
git fetch https://github.com/shine911/android_device_samsung_u8500-common slimkat
git cherry-pick cd75100ef6fe967608994932c56825030c4f77cf
git cherry-pick 15e763609b9a8c2f06ccbae43892c2eca08e36cd
git cherry-pick 5e479e358469cd96277f3d5cd2dfc055a074177d
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