from __future__ import absolute_import, division, print_function

from setuptools import setup, find_packages
from os.path import join, dirname

# GenomicConsensus implicitly depends on
# - ConsensusCore (Quiver/RSII)
# - ConsensusCore2 (Arrow/Sequel)
# adding these in 'install_requires' would
# make integration unnecessarily hard

setup(
    name='GenomicConsensus',
    version='2.3.1',  # don't forget to update GenomicConsensus/__init__.py and doc/conf.py too
    author='Pacific Biosciences',
    author_email='devnet@pacificbiosciences.com',
    license=open('LICENSES').read(),
    scripts=[
        'bin/variantCaller',
        'bin/summarizeConsensus',
        'bin/gffToVcf',
        'bin/gffToBed',
        'bin/plurality',
        'bin/poa',
        'bin/quiver',
        'bin/arrow'],
    packages=find_packages(),
    include_package_data=True,
    zip_safe=False,
    setup_requires=['setuptools'],
    install_requires=[
        'pbcore >= 1.2.9',
        'pbcommand >= 0.3.20',
        'numpy >= 1.6.0']
)
