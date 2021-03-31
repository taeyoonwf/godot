scons p=osx tools=yes module_mono_enabled=yes target=release_debug -j8 mono_prefix=/Library/Frameworks/Mono.framework/Versions/Current

mkdir -p bin/GodotSharp/Tools/aot-compilers/iphone-arm64
cp /Users/${USER}/mono-installs/ios-cross-arm64-release/bin/aarch64-apple-darwin-mono-sgen bin/GodotSharp/Tools/aot-compilers/iphone-arm64/

scons p=iphone target=release_debug arch=arm64 module_mono_enabled=yes -j8 mono_prefix=/Users/${USER}/mono-installs/ios-arm64-release
scons p=iphone target=release_debug arch=x86_64 module_mono_enabled=yes -j8 mono_prefix=/Users/${USER}/mono-installs/ios-x86_64-release
scons p=iphone target=release arch=arm64 module_mono_enabled=yes -j8 mono_prefix=/Users/${USER}/mono-installs/ios-arm64-release
scons p=iphone target=release arch=x86_64 module_mono_enabled=yes -j8 mono_prefix=/Users/${USER}/mono-installs/ios-x86_64-release

mkdir -p bin/iphone
cp -r misc/dist/ios_xcode/* bin/iphone/

lipo -create bin/libgodot.iphone.opt.arm64.a bin/libgodot.iphone.opt.x86_64.a -output bin/iphone/libgodot.iphone.release.fat.a
lipo -create bin/libgodot.iphone.opt.debug.arm64.a bin/libgodot.iphone.opt.debug.x86_64.a -output bin/iphone/libgodot.iphone.debug.fat.a
lipo -create bin/libgodot_camera_module.iphone.opt.arm64.a bin/libgodot_camera_module.iphone.opt.x86_64.a -output bin/iphone/libgodot_camera_module.iphone.release.fat.a
lipo -create bin/libgodot_camera_module.iphone.opt.debug.arm64.a bin/libgodot_camera_module.iphone.opt.debug.x86_64.a -output bin/iphone/libgodot_camera_module.iphone.debug.fat.a
lipo -create bin/libgodot_arkit_module.iphone.opt.arm64.a bin/libgodot_arkit_module.iphone.opt.x86_64.a -output bin/iphone/libgodot_arkit_module.iphone.release.fat.a
lipo -create bin/libgodot_arkit_module.iphone.opt.debug.arm64.a bin/libgodot_arkit_module.iphone.opt.debug.x86_64.a -output bin/iphone/libgodot_arkit_module.iphone.debug.fat.a

mkdir -p bin/iphone-mono-libs
lipo -create bin/libmonosgen-2.0.iphone.arm64.a bin/libmonosgen-2.0.iphone.x86_64.a -output bin/iphone-mono-libs/libmonosgen-2.0.iphone.fat.a
lipo -create bin/libmono-native.iphone.arm64.a bin/libmono-native.iphone.x86_64.a -output bin/iphone-mono-libs/libmono-native.iphone.fat.a
lipo -create bin/libmono-profiler-log.iphone.arm64.a bin/libmono-profiler-log.iphone.x86_64.a -output bin/iphone-mono-libs/libmono-profiler-log.iphone.fat.a
lipo -create bin/libmono-ee-interp.iphone.arm64.a -output bin/iphone-mono-libs/libmono-ee-interp.iphone.fat.a
lipo -create bin/libmono-icall-table.iphone.arm64.a -output bin/iphone-mono-libs/libmono-icall-table.iphone.fat.a
lipo -create bin/libmono-ilgen.iphone.arm64.a -output bin/iphone-mono-libs/libmono-ilgen.iphone.fat.a

cd bin/iphone
zip iphone.zip * -r
cp iphone.zip /Users/${USER}/Library/Application\ Support/Godot/templates/3.2.3.rc.mono/
cd ../..
cp -r bin/iphone-mono-libs /Users/${USER}/Library/Application\ Support/Godot/templates/3.2.3.rc.mono/

cp -r bin/iphone-mono-libs /Users/${USER}/Library/Application\ Support/Godot/templates/3.2.3.rc.mono/

mkdir -p /Users/${USER}/Library/Application\ Support/Godot/templates/3.2.3.rc.mono/bcl
cp -r /Users/${USER}/mono-installs/ios-bcl/* /Users/${USER}/Library/Application\ Support/Godot/templates/3.2.3.rc.mono/bcl/
cp -r /Users/${USER}/mono-installs/desktop-bcl/* /Users/${USER}/Library/Application\ Support/Godot/templates/3.2.3.rc.mono/bcl/
