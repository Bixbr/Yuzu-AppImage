#!/bin/bash -ex

# Clone Eden, fallback to mirror if upstream repo fails to clone
if ! git clone 'https://git.bixed.xyz/bix/yuzu' ./eden; then
	echo "Using mirror instead..."
	rm -rf ./eden || true
	git clone 'https://git.bixed.xyz/bix/yuzu' ./eden
fi

cd ./eden
git submodule update --init --recursive     

COUNT="$(git rev-list --count HEAD)"
APK_NAME="Eden-${COUNT}-Android-Unofficial-${TARGET}"

cd src/android
chmod +x ./gradlew
	./gradlew assembleRelease --console=plain --info -Dorg.gradle.caching=true

APK_PATH=$(find app/build/outputs/apk -type f -name "*.apk" | head -n 1)
if [ -z "$APK_PATH" ]; then
    echo "Error: APK not found in expected directory."
    exit 1
fi
mkdir -p artifacts
mv "$APK_PATH" "artifacts/$APK_NAME.apk"
