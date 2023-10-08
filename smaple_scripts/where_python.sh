#!/bin/bash
PYTHON_INSTALL_PATH=$(python -c "import sys; import sys; sys.stdout.write(sys.prefix)")
echo $PYTHON_INSTALL_PATH
