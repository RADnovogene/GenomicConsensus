#!/bin/bash -e
echo "# DEPENDENCIES"
echo "## Load modules"
source /mnt/software/Modules/current/init/bash
module load git/2.8.3
module load gcc/6.4.0
module load python/2.7.9 virtualenv
module load zlib/1.2.5
module load cmake ninja
module load swig/3.0.12 ccache boost cram
module load cram/0.7
module load mummer/3.23
module load exonerate/2.0.0
module load blasr/2.3.0
module load gfftools/dalexander

source venv/bin/activate

set -vxeuo pipefail

# TEST

## CC2 version test
python -c "import ConsensusCore2 ; print ConsensusCore2.__version__"

## To use .cmp.h5, pbcore needs h5py.
pip install h5py

## test GC
make unit-tests

## test GC cram
make basic-tests

## test GC extra
make extra-tests

## test GC internal
make internal-tests

set +u
deactivate
set -u
