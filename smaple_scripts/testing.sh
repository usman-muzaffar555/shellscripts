#!/bin/bash

awk '{ print $0}' /etc/passwd
PYTHON_INSTALL_PATH=$(python -c "import sys; import sys; sys.stdout.write(sys.prefix)")

sed "hello" geekfile.txt
