#!/bin/bash


tar c test.zip bin lib/{lib-dynload,plat-linux,python35.zip} | nc -w5 -vvlp1234 && exit
tar c test.zip bin lib/{lib-dynload,plat-linux,python35.zip} | xz -vvzcT$(nproc) | nc -w5 -vvlp1234 && exit


	#&& rm -rf bin lib python35.zip
