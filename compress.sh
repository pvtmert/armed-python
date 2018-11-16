#!/bin/sh

(cd lib/python3.5 && mv lib-dynload ..)
(cd lib/python3.5 && mv plat-linux ..)
(cd lib/python3.5 && zip -mr ../python35.zip .)

(zip -r test.zip *.py)
(zip -r /tmp/py35.zip bin lib)
