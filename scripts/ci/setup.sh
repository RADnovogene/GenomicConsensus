#!/usr/bin/env bash
set -vex

#########
# SETUP #
#########

pip install --user coverage h5py nose numpy

pip install --user -e _deps/pbcommand
pip install --user -e _deps/pbcore
pip install --user -e _deps/pbtestdata
