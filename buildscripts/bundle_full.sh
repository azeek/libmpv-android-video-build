# --------------------------------------------------

if [ ! -f "deps" ]; then
  sudo rm -r deps
fi
if [ ! -f "prefix" ]; then
  sudo rm -r prefix
fi

./download.sh
./patch.sh

# --------------------------------------------------

if [ ! -f "scripts/ffmpeg" ]; then
  rm scripts/ffmpeg.sh
fi
cp flavors/full.sh scripts/ffmpeg.sh

# --------------------------------------------------

./build.sh

# --------------------------------------------------

cd deps/media-kit-android-helper

sudo chmod +x gradlew
./gradlew assembleRelease

unzip -o app/build/outputs/apk/release/app-release.apk -d app/build/outputs/apk/release

cp app/build/outputs/apk/release/lib/arm64-v8a/libmediakitandroidhelper.so      ../../prefix/arm64-v8a/usr/local/lib
cp app/build/outputs/apk/release/lib/armeabi-v7a/libmediakitandroidhelper.so    ../../prefix/armeabi-v7a/usr/local/lib
cp app/build/outputs/apk/release/lib/x86/libmediakitandroidhelper.so            ../../prefix/x86/usr/local/lib
cp app/build/outputs/apk/release/lib/x86_64/libmediakitandroidhelper.so         ../../prefix/x86_64/usr/local/lib

cd ../..

mkdir -p tmp2/lib/arm64-v8a
mkdir -p tmp2/lib/armeabi-v7a
mkdir -p tmp2/lib/x86
mkdir -p tmp2/lib/x86_64

cp prefix/arm64-v8a/usr/local/lib/*.so tmp2/lib/arm64-v8a/
cp prefix/armeabi-v7a/usr/local/lib/*.so tmp2/lib/armeabi-v7a/
cp prefix/x86/usr/local/lib/*.so tmp2/lib/x86/
cp prefix/x86_64/usr/local/lib/*.so tmp2/lib/x86_64/

(cd tmp2 && zip -r ../full-arm64-v8a.jar lib/arm64-v8a)
(cd tmp2 && zip -r ../full-armeabi-v7a.jar lib/armeabi-v7a)
(cd tmp2 && zip -r ../full-x86.jar lib/x86)
(cd tmp2 && zip -r ../full-x86_64.jar lib/x86_64)

md5sum *.jar
