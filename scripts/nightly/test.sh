#!/bin/bash -e
echo "# DEPENDENCIES"
echo "## Load modules"
source /mnt/software/Modules/current/init/bash
module load git
module load gcc
module load python/2
module load zlib
module load cmake ninja
module load swig ccache boost cram
module load cram
module load mummer
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
