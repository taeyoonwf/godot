rm -rf /root/build
scons p=x11 tools=yes module_mono_enabled=yes mono_glue=no -j8 mono_prefix=/root/mono-installs/desktop-linux-x86_64-release
./bin/godot.x11.tools.64.mono --generate-mono-glue modules/mono/glue
scons p=x11 tools=yes module_mono_enabled=yes target=release_debug -j8 mono_prefix=/root/mono-installs/desktop-linux-x86_64-release
rm ./bin/godot.x11.tools.64.mono
mkdir /root/build
cp -r bin /root/build/

scons p=android target=release_debug android_arch=arm64v8 module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/android-arm64-v8a-release 
scons p=android target=release_debug android_arch=armv7 module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/android-armeabi-v7a-release 
cd /root/godot/platform/android/java
./gradlew generateGodotTemplates && rm -rf /root/android-toolchains

cd /root/godot
mkdir -p /root/build/templates/3.2.3.rc.mono
cp bin/android_* /root/build/templates/3.2.3.rc.mono/
cp -r /root/mono-installs/android-bcl /root/build/templates/3.2.3.rc.mono/bcl
cp -r /root/mono-installs/desktop-bcl/* /root/build/templates/3.2.3.rc.mono/bcl/

cp -r ../build /godot-fix/
