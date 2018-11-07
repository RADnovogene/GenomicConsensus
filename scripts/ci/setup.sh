#!/usr/bin/env bash
set -vex

#########
# SETUP #
#########

WHEELHOUSE="/mnt/software/p/python/wheelhouse/develop/"
pip install --user --find-links=${WHEELHOUSE} coverage h5py nose numpy

pip install --user --find-links=${WHEELHOUSE} -e _deps/pbcommand
pip install --user --find-links=${WHEELHOUSE} -e _deps/pbcore
pip install --user --find-links=${WHEELHOUSE} -e _deps/pbtestdata
