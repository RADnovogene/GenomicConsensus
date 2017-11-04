SHELL = /bin/bash -e
INTERNAL_UTILS_PATH = /mnt/secondary/Share/Quiver/Tools

develop:
	python setup.py develop

tests: unit-tests basic-tests

unit-tests:
	# Unit tests
	py.test --junit-xml=nosetests.xml tests/unit

# Note: We need at least cram/0.7 for '--xunit-file'
# Note: The cram tests often need h5py.

basic-tests:
	# End-to-end tests
	# One of these now needs mummer and exonerate.
	PATH=`pwd`:$(PATH) cram --xunit-file=gc-cram.xml tests/cram/*.t

extra-tests:
	# Tests that need to be run by Jenkins but are slowing
	# down the development cycle, so aren't run by "tests"
	# target.
	PATH=`pwd`:$(PATH) cram --xunit-file=gc-extra-cram.xml tests/cram/extra/*.t

internal-tests:
	# Long running tests that depend on files located on PacBio internal NFS
	# servers, including some utilities (exonerate suite, MuMMer, blasr, gfftools)
	 cram --xunit-file=gc-internal-cram.xml tests/cram/internal/*.t

doc:
	cd doc; make html

clean:
	-rm -rf dist/ build/ *.egg-info
	-rm -rf doc/_build
	-rm -f nosetests.xml coverage.xml
	-find . -name "*.pyc" | xargs rm -f

tags:
	find GenomicConsensus -name "*.py" | xargs etags

# Aliases
docs: doc
check: tests
test: tests

.PHONY: check test tests doc docs clean tags
