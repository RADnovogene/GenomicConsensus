#!/usr/bin/env bash
set -vex

########
# TEST #
########

## CC1 version test
python -c 'import ConsensusCore; print ConsensusCore.Version.VersionString()'

## CC2 version test
python -c 'import ConsensusCore2; print ConsensusCore2.__version__'

## test CC2 via GC
coverage run --source GenomicConsensus -m py.test --verbose --junit-xml=nosetests.xml tests/unit

## Run fairly fast cram tests
make basic-tests

if [[ ${bamboo_shortPlanName} == GenomicConsensus-nightly ]]; then
	## test GC
	make unit-tests

	## test GC cram
	make basic-tests

	## test GC extra
	make extra-tests

	## test GC internal
	make internal-tests
fi
