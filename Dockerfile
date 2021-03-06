FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -yy git python3 python3-pip curl android-sdk wget
WORKDIR /root

RUN wget https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip --quiet && \
    unzip -qq android-ndk-r21e-linux-x86_64.zip && \
    rm -rf android-ndk-r21e-linux-x86_64.zip
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-6858069_latest.zip --quiet && \
    unzip -qq commandlinetools-linux-6858069_latest.zip && \
    rm -rf commandlinetools-linux-6858069_latest.zip
RUN yes | ./cmdline-tools/bin/sdkmanager --install "cmake;3.10.2.4988404" --sdk_root=/usr/lib/android-sdk
RUN ln -s /usr/lib/android-sdk/cmake/3.10.2.4988404/bin/cmake /usr/bin/cmake

ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV ANDROID_NDK_ROOT=/root/android-ndk-r21e

RUN apt install -yy autoconf libtool automake build-essential gettext openjdk-11-jdk
RUN apt install -yy software-properties-common lsb-release apt-transport-https ca-certificates
RUN apt update
RUN apt install -yy libx11-dev libxcursor-dev libxinerama-dev libxrandr-dev libxi-dev libsdl2-dev
RUN pip3 install scons dataclasses

RUN wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm -rf packages-microsoft-prod.deb
RUN apt update && apt install -yy dotnet-sdk-5.0 pkg-config vim

RUN git clone https://github.com/godotengine/godot-mono-builds.git
RUN git clone https://github.com/mono/mono
WORKDIR /root/mono
RUN git checkout mono-6.12.0.130
RUN git submodule update --init --recursive

ENV MONO_SOURCE_ROOT=/root/mono
ENV PATH=${PATH}:/root/mono-configs/bcl/runtime/_tmpinst/bin
ENV LD_LIBRARY_PATH=/root/mono-installs/desktop-linux-x86_64-release/lib

WORKDIR /root/godot-mono-builds
RUN python3 linux.py configure --target=x86_64 && \
    python3 linux.py make  -j8 --target=x86_64 && \
    rm -rf /root/mono-configs
RUN python3 bcl.py make -j8 --product=desktop && \
    rm -rf /root/mono-configs

ENV MONO_PATH=/root/mono-installs/desktop-bcl/net_4_x
RUN python3 bcl.py make -j8 --product=android && \
    rm -rf /root/mono-configs

RUN python3 android.py configure --target=armeabi-v7a --target=arm64-v8a && \
    python3 android.py make  -j8 --target=armeabi-v7a --target=arm64-v8a && \
    rm -rf /root/mono-configs && \
    rm -rf /root/android-toolchains

# build with the godot code from here
WORKDIR /root
RUN git clone https://github.com/taeyoonwf/Godot-AdMob-Android-iOS.git
RUN wget https://github.com/taeyoonwf/Godot-AdMob-Android-iOS/releases/download/v1/googlemobileadssdkios.zip --quiet && \
    unzip -qq googlemobileadssdkios.zip && \
    rm googlemobileadssdkios.zip
RUN git clone https://github.com/taeyoonwf/godot
WORKDIR /root/Godot-AdMob-Android-iOS
RUN git checkout iOS-3.2

WORKDIR /root/godot
RUN git checkout main
RUN cp -r /root/Godot-AdMob-Android-iOS/ios/admob modules/
RUN mv /root/GoogleMobileAdsSdkiOS-7.69.0/* modules/admob/lib/

RUN scons p=x11 tools=yes module_mono_enabled=yes mono_glue=no -j8 mono_prefix=/root/mono-installs/desktop-linux-x86_64-release
RUN ./bin/godot.x11.tools.64.mono --generate-mono-glue modules/mono/glue
RUN scons p=x11 tools=yes module_mono_enabled=yes target=release_debug -j8 mono_prefix=/root/mono-installs/desktop-linux-x86_64-release
RUN rm ./bin/godot.x11.tools.64.mono
RUN mkdir /root/build
RUN cp -r bin /root/build/

RUN scons p=android target=release_debug android_arch=arm64v8 module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/android-arm64-v8a-release
RUN scons p=android target=release_debug android_arch=armv7 module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/android-armeabi-v7a-release
RUN scons p=android target=release android_arch=arm64v8 module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/android-arm64-v8a-release
RUN scons p=android target=release android_arch=armv7 module_mono_enabled=yes -j8 mono_prefix=/root/mono-installs/android-armeabi-v7a-release

WORKDIR /root/godot/platform/android/java
RUN ./gradlew generateGodotTemplates && \
    rm -rf /usr/lib/android-sdk/ndk/* && \
    rm -rf /root/.gradle/*

WORKDIR /root/Godot-AdMob-Android-iOS/android/admob
RUN cp /root/godot/bin/godot-lib.release.aar godot-lib/godot-lib.aar
RUN ./gradlew build && rm -rf /root/.gradle
RUN mkdir -p /root/build/admob/android/plugins
RUN cp -r /root/Godot-AdMob-Android-iOS/admob_api /root/build/admob/
RUN cp admob/build/outputs/aar/* /root/build/admob/android/plugins/

WORKDIR /root/godot
RUN mkdir -p /root/build/templates/3.2.3.rc.mono
RUN cp bin/android_* /root/build/templates/3.2.3.rc.mono/
RUN cp -r /root/mono-installs/android-bcl /root/build/templates/3.2.3.rc.mono/bcl
RUN cp -r /root/mono-installs/desktop-bcl/* /root/build/templates/3.2.3.rc.mono/bcl/

WORKDIR /root
COPY Dockerfile ./
