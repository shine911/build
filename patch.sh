BASEDIR=$(pwd)
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
cd frameworks/base
	git fetch http://review.cyanogenmod.org/CyanogenMod/android_frameworks_base refs/changes/34/63034/2
	git cherry-pick FETCH_HEAD
	git apply --stat $BASEDIR/patch/patches/OK-Google.patch
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
echo -e $CL_BLU"Cherrypicking from my device common tree"$CL_RST
cd device/samsung/u8500-common
	git fetch https://github.com/shine911/android_device_samsung_u8500-common slimkat
	git cherry-pick e262ecc39146eb8fbbba8dc9b4209ea65b416905
	git cherry-pick 5e479e358469cd96277f3d5cd2dfc055a074177d
	git cherry-pick d0b983f7eeb20e18949d6bfde62b22504b3d3e5e
cd ../../../
echo -e $CL_BLU"Cherrypicking Low-incall Volume Fix"$CL_RST
cd packages/services/Telephony
	git fetch https://github.com/shine911/android_packages_services_Telephony kitkat
	git cherry-pick b9aecf8f6c30c74067e324c212db7e90f8ce3091
cd ../../..