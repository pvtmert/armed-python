#!/usr/bin/env docker build --compress -t pvtmert/python -f

FROM pvtmert/gcc-arm:gnueabi

ENV version=3.5.3

RUN apt update && \
	apt install -y python3-dev:armel zlib1g-dev:armel \
	libz-dev:armel libcrypto++-dev:armel libssl-dev:armel \
	libreadline-dev:armel libreadline5:armel libc-dev:armel libc6-dev:armel \
	&& apt clean

ADD https://www.python.org/ftp/python/${version}/Python-${version}.tar.xz /
RUN tar xvf Python-${version}.tar.xz
#RUN curl -vskL \
#	https://t.elektromanye.tk/Python-${version}.tar.xz \
#	| tar xvJ

COPY modules.txt Python-${version}/Modules/Setup.local

RUN mkdir -p build && cd build && ../Python-${version}/configure \
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
		--with-libs=" -l:libreadline.so.5 -lcrypt -ldl -lz "

RUN mkdir -p cache && \
	make -C build -j - clean && \
	make -C build -j $(( 1 * $(nproc) )) python && \
	make -C build -j $(( 1 * $(nproc) )) build_all && \
	make -C build -j - bininstall libinstall sharedinstall

COPY clean.sh compress.sh /cache/
RUN cd cache && sh clean.sh && sh compress.sh
RUN rm -rf Python-${version}{,.tar.xz} build
