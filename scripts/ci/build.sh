#!/usr/bin/env bash
set -vex

#########
# BUILD #
#########

# install
WHEELHOUSE="/mnt/software/p/python/wheelhouse/develop/"
pip install --user --find-links=${WHEELHOUSE} -e .

# produce wheel
python setup.py bdist_wheel
