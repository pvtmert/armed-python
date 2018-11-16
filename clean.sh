#!/bin/sh

find . -iname test -exec rm -rf {} +
find . -iname tests -exec rm -rf {} +


rm -rf \
	lib/libpython3.5.a \
	xlib/python3.5/idlelib \
	lib/python3.5/ensurepip \
	xlib/python3.5/lib-dynload \
	lib/python3.5/distutils/command \

find bin -type f -exec arm-linux-gnueabi-strip -s {} +
find lib -type f -iname "*.so" -exec arm-linux-gnueabi-strip -s {} +

./bin/python3.5 -OO -m compileall -j 0 -d lib -f -b lib
find lib -type f -iname "*.py" -exec rm -rf {} +

find . -iname __pycache__ -exec rm -rf {} +

exit 0
