#!/bin/bash
set -euo pipefail

echo "# DEPENDENCIES"
echo "## Load modules"
source /mnt/software/Modules/current/init/bash
module load git/2.8.3
module load gcc/6.4.0
module load python/2.7.9 virtualenv
module load zlib/1.2.5
module load cmake ninja
module load swig ccache boost cram

set +u
source venv/bin/activate
set -u

echo "# TEST"

echo "## CC2 version test"
python -c "import ConsensusCore2 ; print ConsensusCore2.__version__"

echo "## test GC"
make check

echo "## test GC extra"
make extra-tests

echo "## test GC internal"
make internal-tests

set +u
deactivate
set -u
