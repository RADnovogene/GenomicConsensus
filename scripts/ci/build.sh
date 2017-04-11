#!/bin/bash
set -euo pipefail

echo "# DEPENDENCIES"
echo "## Load modules"
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load git/2.8.3
module load gcc/4.9.2
module load cmake ninja
module load swig ccache boost cram
CXX="$CXX -static-libstdc++"
GXX="$CXX"
export CXX GXX
CCACHE_BASEDIR=$PWD
CCACHE_DIR=/mnt/secondary/Share/tmp/bamboo.mobs.ccachedir
CCACHE_DIR=$PWD/.pip
export CCACHE_BASEDIR CCACHE_DIR

echo "## Use PYTHONUSERBASE in lieu of virtualenv"
export PATH=$PWD/build/bin:/mnt/software/a/anaconda2/4.2.0/bin:$PATH
export PYTHONUSERBASE=$PWD/build
# pip 9 create some problem with egg style install so don't upgrade pip
PIP="pip --cache-dir=$PWD/.pip --disable-pip-version-check"

echo "## Install pip modules"
NX3PBASEURL=http://nexus/repository/unsupported/pitchfork/gcc-4.9.2
NXSABASEURL=http://nexus/repository/maven-snapshots/pacbio/sat
$PIP install --user \
  $NX3PBASEURL/pythonpkgs/pysam-0.9.1.4-cp27-cp27mu-linux_x86_64.whl \
  $NX3PBASEURL/pythonpkgs/xmlbuilder-1.0-cp27-none-any.whl \
  $NX3PBASEURL/pythonpkgs/avro-1.7.7-cp27-none-any.whl \
  iso8601 \
  $NX3PBASEURL/pythonpkgs/tabulate-0.7.5-cp27-none-any.whl \
  coverage
ln -sfn ../data _deps/pacbiotestdata/pbtestdata/data
$PIP install --user -e _deps/pacbiotestdata
$PIP install --user -e _deps/pbcore
$PIP install --user -e _deps/pbcommand

echo "## Get external dependencies"
curl -s -L $NX3PBASEURL/zlib-1.2.8.tgz                 | tar zxf - -C build
curl -s -L $NXSABASEURL/htslib/htslib-1.1-SNAPSHOT.tgz | tar zxf - -C build

echo "## Fetch unanimity \"submodules\""
( cd _deps/unanimity \
  && git checkout . \
  && git clean -xdf \
  && rm -rf third-party/seqan third-party/pbbam third-party/pbcopper \
  && ln -sfn $PWD/../seqan    third-party/seqan \
  && ln -sfn $PWD/../pbbam    third-party/pbbam \
  && ln -sfn $PWD/../pbcopper third-party/pbcopper )
# the reason to use $PWD/.. full path is that pip will copy it to /tmp

echo "# BUILD"
echo "## pip install CC2"
( cd _deps/unanimity \
  && CMAKE_BUILD_TYPE=ReleaseWithAssert \
     CMAKE_COMMAND=cmake \
     ZLIB_INCLUDE_DIR=$PWD/../../build/include \
     ZLIB_LIBRARY=$PWD/../../build/lib/libz.so \
     VERBOSE=1 $PIP install --user --verbose . )

echo "## install ConsensusCore"
( cd _deps/ConsensusCore \
  && python setup.py bdist_wheel --boost=$BOOST_ROOT \
  && echo dist/ConsensusCore-*.whl | \
     xargs $PIP install --user --verbose )

echo "## install GC"
$PIP install --user --verbose .

echo "# TEST"
echo "## CC2 version test"
python -c "import ConsensusCore2 ; print ConsensusCore2.__version__"

echo "## test CC2 via GC"
#nosetests --verbose --with-xunit --xunit-file=nosetests.xml --with-coverage --cover-xml --cover-xml-file=coverage.xml tests/unit
coverage run --source GenomicConsensus -m py.test --verbose --junit-xml=nosetests.xml tests/unit
coverage xml -o coverage.xml
sed -i -e 's@filename="@filename="./@g' coverage.xml

cd build
tar zcf ConsensusCore-SNAPSHOT.tgz \
  lib/python2.7/site-packages/ConsensusCore.* \
  lib/python2.7/site-packages/ConsensusCore-* \
  lib/python2.7/site-packages/_ConsensusCore.*
tar zcf ConsensusCore2-SNAPSHOT.tgz \
  lib/python2.7/site-packages/ConsensusCore2.* \
  lib/python2.7/site-packages/ConsensusCore2-* \
  lib/python2.7/site-packages/_ConsensusCore2.*
tar zcf GenomicConsensus-SNAPSHOT.tgz \
  lib/python2.7/site-packages/GenomicConsensus* \
  bin/arrow \
  bin/gffToBed \
  bin/gffToVcf \
  bin/plurality \
  bin/poa \
  bin/quiver \
  bin/summarizeConsensus \
  bin/variantCaller
if [ "_$bamboo_planRepository_1_branch" = "_develop" ]; then
  NEXUS_BASEURL=http://ossnexus.pacificbiosciences.com/repository
  NEXUS_URL=$NEXUS_BASEURL/unsupported/gcc-4.9.2
  curl -v -n --upload-file ConsensusCore-SNAPSHOT.tgz $NEXUS_URL/pythonpkgs/ConsensusCore-SNAPSHOT.tgz
  curl -v -n --upload-file ConsensusCore2-SNAPSHOT.tgz $NEXUS_URL/pythonpkgs/ConsensusCore2-SNAPSHOT.tgz
  curl -v -n --upload-file GenomicConsensus-SNAPSHOT.tgz $NEXUS_URL/pythonpkgs/GenomicConsensus-SNAPSHOT.tgz
fi
