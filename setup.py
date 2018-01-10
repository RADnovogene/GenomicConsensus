from setuptools import setup, find_packages
from os.path import join, dirname

setup(
    name = 'GenomicConsensus',
    version='2.2.2',
    author='Pacific Biosciences',
    author_email='devnet@pacificbiosciences.com',
    license=open('LICENSES').read(),
    scripts = ['bin/variantCaller',
               'bin/summarizeConsensus',
               'bin/gffToVcf',
               'bin/gffToBed',
               'bin/plurality',
               'bin/poa',
               'bin/quiver',
               'bin/arrow'],
    packages = find_packages(),
    package_data={'GenomicConsensus.quiver': ['resources/*/GenomicConsensus/*.ini']},
    include_package_data=True,
    zip_safe = False,
    install_requires=[
        'pbcore >= 1.2.9',
        'pbcommand >= 0.3.20',
        'numpy >= 1.6.0',
        #'h5py >= 2.0.1',
        #'ConsensusCore == 1.0.2'
        # , 'ConsensusCore2 >= 0.9',
        ]
    )
