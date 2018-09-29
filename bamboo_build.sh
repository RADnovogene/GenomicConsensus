#!/usr/bin/env bash
set -vex

################
# DEPENDENCIES #
################

## Load modules
type module >& /dev/null || . /mnt/software/Modules/current/init/bash

module purge

# python deps
module load python/2
module load cram
module load swig

# One fairly fast cram-test,
#   quiver-tinyLambda-coverage-islands.t,
# was moved from cram/internal. It needs some GNU modules.
# If that becomes a problem, just move it back to cram/internal.
module load mummer
module load blasr/2.3.0
module load exonerate/2.0.0
module load gfftools/dalexander

case "${bamboo_planRepository_branchName}" in
  master)
    module load ConsensusCore/master
    module load unanimity/master
    ;;
  *)
    module load ConsensusCore/develop
    module load unanimity/develop
    ;;
esac

## Use PYTHONUSERBASE in lieu of virtualenv
export PYTHONUSERBASE="${PWD}/build"
export PATH="${PYTHONUSERBASE}/bin:${PATH}"

source scripts/ci/setup.sh
source scripts/ci/build.sh
source scripts/ci/test.sh
