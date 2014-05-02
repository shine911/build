echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_av"$CL_RST
cd frameworks/av
git fetch https://github.com/shine911/AOKP_frameworks_av kitkat
git cherry-pick 41fe83859e80a06be98e33b194aa6c6ff3b3a063
cd ..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_native"$CL_RST
cd native
git fetch https://github.com/shine911/AOKP_frameworks_native kitkat
git cherry-pick 8aa591b329373df590402ed7752906a8fa65a624
echo -e $CL_BLU"Cherrypicking Legacy sensors"$CL_RST
git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_native refs/changes/11/59311/1
git cherry-pick FETCH_HEAD
cd ../..
echo -e $CL_BLU"Cherrypicking OMX Patch - android_frameworks_base"$CL_RST
cp patch/patches/frameworks/base/core/jni/android_media_AudioRecord.cpp frameworks/base/core/jni/android_media_AudioRecord.cpp
echo -e $CL_BLU"Cherrypicking Core Patch - OMX, reboot/shutdown fix and samsung: allow lpm from command line"$CL_RST
cp patch/patches/system/core/init/init.c system/core/init/init.c
cd system/core
git fetch https://github.com/shine911/AOKP_system_core kitkat
git cherry-pick 8a88ebcc6c34ac5ba16f1b16660b8594ae6f86a6
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