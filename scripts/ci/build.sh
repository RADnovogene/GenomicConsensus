#!/bin/bash
set -euo pipefail

echo "# DEPENDENCIES"
echo "## Load modules"
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load git/2.8.3
module load gcc/4.9.2
module load cmake ninja
module load swig ccache boost
CXX="$CXX -static-libstdc++"
GXX="$CXX"
export CXX GXX

echo "## Use PYTHONUSERBASE in lieu of virtualenv"
export PATH=$PWD/build/bin:/mnt/software/a/anaconda2/4.2.0/bin:$PATH
export PYTHONUSERBASE=$PWD/build
# pip 9 create some problem with egg style install
PIP="pip --cache-dir=$PWD/.pip --disable-pip-version-check"

echo "## Install pip modules"
NX3PBASEURL=http://nexus/repository/maven-thirdparty/gcc-4.9.2
NXSABASEURL=http://nexus/repository/maven-snapshots/pacbio/sat
$PIP install --user \
  $NX3PBASEURL/pythonpkgs/pysam-0.9.1.4-cp27-cp27mu-linux_x86_64.whl \
  $NX3PBASEURL/pythonpkgs/xmlbuilder-1.0-cp27-none-any.whl \
  $NX3PBASEURL/pythonpkgs/avro-1.7.7-cp27-none-any.whl \
  iso8601 \
  $NX3PBASEURL/pythonpkgs/tabulate-0.7.5-cp27-none-any.whl \
  cram \
  coverage
ln -sfn ../data _deps/PacBioTestData/pbtestdata/data
$PIP install --user -e _deps/PacBioTestData
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

echo "# BUILD"
echo "## pip install CC2"
( cd _deps/unanimity \
  && CMAKE_BUILD_TYPE=ReleaseWithAssert \
     CMAKE_COMMAND=cmake \
     ZLIB_INCLUDE_DIR=$PWD/../../build/include \
     ZLIB_LIBRARY=$PWD/../../build/lib/libz.so \
     VERBOSE=1 $PIP install --user --verbose -e . )

echo "## install ConsensusCore"
( cd _deps/ConsensusCore \
  && python setup.py install --user --boost=$BOOST_ROOT )

echo "## install GC"
$PIP install --user --verbose -e .

echo "# TEST"
echo "## CC2 version test"
python -c "import ConsensusCore2 ; print ConsensusCore2.__version__"

echo "## test CC2 via GC"
nosetests --verbose --with-xunit --xunit-file=nosetests.xml --with-coverage --cover-xml --cover-xml-file=coverage.xml tests/unit
sed -i -e 's@filename="@filename="./@g' coverage.xml
