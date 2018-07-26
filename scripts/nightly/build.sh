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

echo "## Get into virtualenv"
if [ ! -d venv ]
then
    virtualenv venv
fi

source venv/bin/activate

set -vxeuo pipefail


## Install pip modules
pip install --upgrade pip

pip install cython pysam cram pytest coverage jsonschema avro nose numpy==1.14.5
pip install --no-deps http://bitbucket:7990/rest/api/latest/projects/SL/repos/pbcommand/archive?format=zip
pip install --no-deps http://bitbucket:7990/rest/api/latest/projects/SAT/repos/pbcore/archive?format=zip

### Get PacBioTestData
if [ ! -d ../PacBioTestData ]
then
    ( cd ..                                                            &&\
    git clone https://github.com/PacificBiosciences/PacBioTestData.git )
fi
( cd ../PacBioTestData                                                    &&\
    git lfs pull                                                       &&\
    make python )

## Fetch unanimity submodules
# Bamboo's checkout of unanimity doesn't set the "origin" remote to
# something meaningful, which means we can't resolve the relative
# submodules.  Override the remote here.
( cd ../unanimity &&
  git remote set-url origin ssh://git@bitbucket:7999/sat/unanimity.git &&
  git submodule update --init --remote )

# BUILD

## pip install CC2
( cd ../unanimity && CMAKE_BUILD_TYPE=ReleaseWithAssert CMAKE_COMMAND=cmake ZLIB_INCLUDE_DIR=/mnt/software/z/zlib/1.2.5/include ZLIB_LIBRARY=/mnt/software/z/zlib/1.2.5/lib/libz.so VERBOSE=1 pip install --verbose --upgrade --no-deps . )

## install ConsensusCore
( cd ../ConsensusCore && python setup.py install --boost=$BOOST_ROOT )

## install GC
( pip install --upgrade --no-deps --verbose . )

set +u
deactivate
set -u
