rm -rf /root/build
scons p=x11 tools=yes module_mono_enabled=yes mono_glue=no -j8 mono_prefix=/root/mono-installs/desktop-linux-x86_64-release
./bin/godot.x11.tools.64.mono --generate-mono-glue modules/mono/glue
mkdir /root/build
cp -r bin /root/build/

scons p=javascript target=release_debug tools=no module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/wasm-runtime-release
scons p=javascript target=release tools=no module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/wasm-runtime-release

mv bin/godot.javascript.opt.mono.zip bin/webassembly_release.zip
mv bin/godot.javascript.opt.debug.mono.zip bin/webassembly_debug.zip

cd /root/godot
mkdir -p /root/build/templates/3.2.3.rc.mono
cp bin/webassembly_* /root/build/templates/3.2.3.rc.mono/
cp -r /root/mono-installs/wasm-bcl /root/build/templates/3.2.3.rc.mono/bcl

cp -r ../build/* /build/
