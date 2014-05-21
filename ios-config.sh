configure_for_platform() {
	export PLATFORM=$1
	#export PLATFORM=iPhoneOS 
	echo "Platform is ${PLATFORM}"

	if [ "$PLATFORM" == "iPhoneSimulator" ]; then
		export ARCHITECTURE=i386
		export ARCH=i686-apple-darwin10
	fi

	if [ "$PLATFORM" == "iPhoneOS" ]; then
		export ARCHITECTURE=$2
		export ARCH=arm-apple-darwin10 
	fi

	export ARCH_PREFIX=$ARCH- 
	export SDKVER="6.0" 
	export DEVROOT=/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer 
	export SDKROOT="$DEVROOT/SDKs/${PLATFORM}$SDKVER.sdk" 
	export PKG_CONFIG_PATH="$SDKROOT/usr/lib/pkgconfig:$DEVROOT/usr/lib/pkgconfig" 
	export AS="$DEVROOT/usr/bin/as" 
	export ASCPP="$DEVROOT/usr/bin/as" 
	export AR="$DEVROOT/usr/bin/ar" 
	export RANLIB="$DEVROOT/usr/bin/ranlib" 
	#export CPP="$DEVROOT/usr/bin/c++" 
	#export CXXCPP="$DEVROOT/usr/bin/c++" 
	export CC="$DEVROOT/usr/bin/gcc" 
	export CXX="$DEVROOT/usr/bin/g++" 
	export LD="$DEVROOT/usr/bin/ld" 
	export STRIP="$DEVROOT/usr/bin/strip" 
	export LIBRARY_PATH="$SDKROOT/usr/lib"

	export CPPFLAGS="" 
	#export CFLAGS="-arch armv7 -fmessage-length=0 -pipe -fpascal-strings -miphoneos-version-min=4.0 -isysroot=$SDKROOT -I$SDKROOT/usr/include -I$SDKROOT/usr/include/c++/4.2.1/" 
	export CFLAGS="-arch ${ARCHITECTURE} -fmessage-length=0 -pipe -fpascal-strings -miphoneos-version-min=4.0 -isysroot=$SDKROOT -I$SDKROOT/usr/include -I$SDKROOT/usr/include/c++/4.2.1/" 
	export CXXFLAGS="$CFLAGS" 
	#export LDFLAGS="-isysroot='$SDKROOT' -L$SDKROOT/usr/lib/system -L$SDKROOT/usr/lib/"
	export LDFLAGS="-arch ${ARCHITECTURE} -isysroot='$SDKROOT' -L$SDKROOT/usr/lib/system -L$SDKROOT/usr/lib/"

	./configure --host=${ARCH} --with-protoc=protoc --enable-static --disable-shared 
}


mkdir ios-build

#build for iPhoneSimulator
configure_for_platform iPhoneSimulator
make clean
make
cp src/.libs/libprotobuf-lite.a ios-build/libprotobuf-lite-i386.a

#build for iPhoneOS armv7
configure_for_platform iPhoneOS armv7
make clean
make
cp src/.libs/libprotobuf-lite.a ios-build/libprotobuf-lite-armv7.a

#build for iPhoneOS armv7s
configure_for_platform iPhoneOS armv7s
make clean
make
cp src/.libs/libprotobuf-lite.a ios-build/libprotobuf-lite-armv7s.a

#build for iPhoneOS arm64
configure_for_platform iPhoneOS arm64
make clean
make
cp src/.libs/libprotobuf-lite.a ios-build/libprotobuf-lite-arm64.a

make clean

#cerate a fat library containing all achitectures in libprotobuf-lite.a
xcrun -sdk iphoneos lipo -arch armv7 ios-build/libprotobuf-lite-armv7.a -arch armv7s ios-build/libprotobuf-lite-armv7s.a -arch arm64 ios-build/libprotobuf-lite-arm64.a -arch i386 ios-build/libprotobuf-lite-i386.a -create -output ios-build/libprotobuf-lite.a



