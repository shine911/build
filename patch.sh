echo -e $CL_BLU"RESET ALL COMMIT"$CL_RST
repo forall -c "git reset --hard"
echo -e $CL_BLU"Starting Patching..."$CL_RST
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_av"$CL_RST
cd frameworks/av
git fetch https://github.com/shine911/frameworks_av kk4.4
git cherry-pick 97b2d13620053eaa8b3425d3bbb486b2c4ef5a9f
cd ..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_native"$CL_RST
cd native
git fetch https://github.com/shine911/frameworks_native kk4.4
git cherry-pick e7c8482bf9e3287c81962ad573d8562995a388bc
echo -e $CL_BLU"Cherrypicking Legacy sensors"$CL_RST
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/11/59311/1
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_base"$CL_RST
cp patches/frameworks/base/core/jni/android_media_AudioRecord.cpp frameworks/base/core/jni/android_media_AudioRecord.cpp
echo -e $CL_BLU"Cherrypicking Core Patch - OMX, reboot/shutdown fix and samsung: allow lpm from command line"$CL_RST
cp patches/system/core/init/init.c system/core/init/init.c
cd system/core
git fetch https://github.com/shine911/android_system_core kk4.4
git cherry-pick bef1a23e42c532b5f06fa54878434995478b1f54
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
git cherry-pick 6e18ab650a9bc6f4d16df7160569a6d45415e9ec
cd ../../..
echo -e $CL_BLU"DONE!"$CL_RST