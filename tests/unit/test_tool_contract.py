from __future__ import absolute_import, division, print_function

import unittest
import os.path

from GenomicConsensus.options import Constants
from pbcore.io import ContigSet
import pbcommand.testkit

import pbtestdata

DATA_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "data")
assert os.path.isdir(DATA_DIR)

class TestVariantCaller(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = "variantCaller "
    DRIVER_EMIT = DRIVER_BASE + " --emit-tool-contract "
    DRIVER_RESOLVE = DRIVER_BASE + " --resolved-tool-contract "
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        pbtestdata.get_file("aligned-xml"), pbtestdata.get_file("lambdaNEB")
    ]
    TASK_OPTIONS = {
      "genomic_consensus.task_options.min_coverage": 0,
      "genomic_consensus.task_options.min_confidence": 0,
      "genomic_consensus.task_options.algorithm": "quiver",
      "genomic_consensus.task_options.diploid": False,
    }

    def run_after(self, rtc, output_dir):
        contigs_file = rtc.task.output_files[2]
        with ContigSet(contigs_file, strict=True) as ds:
            pass


class TestVariantCallerArrow(TestVariantCaller):
    TASK_OPTIONS = {
      "genomic_consensus.task_options.algorithm": "arrow",
    }

    def run_after(self, rtc, output_dir):
        super(TestVariantCallerArrow, self).run_after(rtc, output_dir)
        self.assertTrue(bool(rtc.task.options[Constants.MASKING_ID]))


class TestGffToBed(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = "gffToBed "
    DRIVER_EMIT = DRIVER_BASE + " --emit-tool-contract "
    DRIVER_RESOLVE = DRIVER_BASE + " --resolved-tool-contract "
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        os.path.join(DATA_DIR, "converters", "variants.gff.gz"),
    ]
    TASK_OPTIONS = {
        "genomic_consensus.task_options.track_name": "None",
        "genomic_consensus.task_options.track_description": "None",
        "genomic_consensus.task_options.use_score": 0,
    }


class TestGffToVcf(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = "gffToVcf"
    DRIVER_EMIT = DRIVER_BASE + " --emit-tool-contract "
    DRIVER_RESOLVE = DRIVER_BASE + " --resolved-tool-contract "
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        os.path.join(DATA_DIR, "converters", "variants.gff.gz"),
    ]
    TASK_OPTIONS = {
        "genomic_consensus.task_options.global_reference": "Staphylococcus_aureus_USA300_TCH1516",
    }


class TestSummarizeConsensus(pbcommand.testkit.PbTestApp):
    DRIVER_BASE = "summarizeConsensus"
    DRIVER_EMIT = DRIVER_BASE + " --emit-tool-contract "
    DRIVER_RESOLVE = DRIVER_BASE + " --resolved-tool-contract "
    REQUIRES_PBCORE = True
    INPUT_FILES = [
        pbtestdata.get_file("alignment-summary-gff"),
        pbtestdata.get_file("variants-gff")
    ]
    TASK_OPTIONS = {}


if __name__ == "__main__":
    unittest.main()
