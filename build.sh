#!/bin/bash -e

	#cp $(dirname $(realpath $0))/modules Modules/Setup.local
	rm -rf build
	mkdir -p build
	cd build

	#apt install -y \
	#	gcc-arm-linux-gnueabi \
	#	libreadline-dev:armel \
	#	libcrypto++-dev:armel \
	#	libssl-dev:armel \
	#	libz-dev:armel \

	../configure \
		--prefix="/cache" \
		--without-pymalloc \
		--without-ensurepip \
		--disable-profiling \
		--disable-shared \
		--disable-ipv6 \
		--enable-_static \
		--enable-_shared \
		--enable-mutiarch \
		--enable-optimizations \
		--build=x86_64-linux-gnu \
		--host=arm-linux-gnueabi \
		--target=arm-linux-gnueabi \
		CFLAGS="-march=armv6 -mglibc -s -v " \
		LDFLAGS=" -fPIC -static-libgcc -static-libstdc++ " \
		__LINKFORSHARED="-Wl,-E -Wl,--no-dynamic-linker -Wl,-I/lib/ld-linux.so.3 " \
		LINKFORSHARED=" -s -Wl,-E " \
		CROSS_COMPILE_TARGET=yes \
		ac_cv_file__dev_ptmx=no \
		ac_cv_file__dev_ptc=no \
		--with-libs=" -l:libreadline.so.5 -lcrypt -ldl -lz " \
		#--with-libm=" /cache/org/libm.so.6 " \
		#--with-libc=" /cache/org/libc.so.6 " \
		#--with-libs=" /cache/org/libdl.so.2 /cache/org/libpthread.so.0 /cache/org/libz.so.1" \
		#--with-libs=" -l:libz.a -l:libpthread.a -l:libdl.a -l:libcrypt.a " \
		#--with-libs="-L/cache/org /cache/org/libdl.so.2 /cache/org/libpthread.so.0 /cache/org/libz.so.1" \

	make -j - clean

	make -j $(( 1 * $(nproc) )) \
		python \
		build_all \
		#bininstall \
		#libinstall \
		#sharedinstall \

	#./python -c 'import socket; socket.gethostbyname("google.com")'
