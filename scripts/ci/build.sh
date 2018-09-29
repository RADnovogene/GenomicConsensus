#!/usr/bin/env bash
set -vex

#########
# BUILD #
#########

# install
pip install --user -e .

# produce wheel
python setup.py bdist_wheel
