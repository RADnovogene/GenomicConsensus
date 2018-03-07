from __future__ import absolute_import, division, print_function

from numpy.testing import assert_array_almost_equal
from nose.tools import assert_equal as EQ

from GenomicConsensus.quiver import utils
from GenomicConsensus.variants import *
from ConsensusCore import *

class TestVariantsFromAlignment(object):

    def testVariantsFromAlignment1(self):
        a = PairwiseAlignment("GATTACA", "GAT-ACA")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1003, 1004, "T", "", refPrev="T", readPrev="T") ], vs)

    def testVariantsFromAlignment2(self):
        a = PairwiseAlignment("GA-TTACA", "GATTTACA")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1002, 1002, "", "T", refPrev="A", readPrev="A") ], vs)

    def testVariantsFromAlignment3(self):
        a = PairwiseAlignment("GATTACA", "GAGGACA")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1002, 1004, "TT", "GG", refPrev="A", readPrev="A") ], vs)

    def testVariantsFromAlignment4(self):
        a = PairwiseAlignment("GA-TACA", "GATTACA")
        qvs = [0, 0, 1, 0, 0, 0, 0]
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000), qvs)
        EQ([ Variant(1, 1002, 1002, "", "T", confidence=1, refPrev="A", readPrev="A") ], vs)

    def testVariantsFromAlignment5(self):
        a = PairwiseAlignment("-ATTACA", "GATTACA")
        qvs = [1, 0, 0, 0, 0, 0, 0]
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000), qvs)
        EQ([ Variant(1, 1000, 1000, "", "G", confidence=1, refPrev="N", readPrev="N") ], vs)

    def testVariantsFromAlignment6(self):
        a = PairwiseAlignment("GATTAC-", "GATTACA")
        qvs = [0, 0, 0, 0, 0, 0, 1]
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000), qvs)
        EQ([ Variant(1, 1006, 1006, "", "A", confidence=1, refPrev="C", readPrev="C") ], vs)


    def testNoCallBasesInReference1(self):
        a = PairwiseAlignment("GATTNGATT", "GAGGATATT")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1002, 1004, "TT", "GG", refPrev="A", readPrev="A"),
             Variant(1, 1005, 1006, "G",  "T", refPrev="N", readPrev="A")   ], vs)

    def testLongInsertion(self):
        a = PairwiseAlignment("GA-----TTACA", "GACCCCCTTACA")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1002, 1002, "", "CCCCC", refPrev="A", readPrev="A") ], vs)

    def testLongDeletion(self):
        a = PairwiseAlignment("GACCCCCTTACA", "GA-----TTACA")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1002, 1007, "CCCCC", "", refPrev="A", readPrev="A") ], vs)

    def testTwoSubstitutions(self):
        a = PairwiseAlignment("GATTACA", "GAGTAGA")
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000))
        EQ([ Variant(1, 1002, 1003, "T", "G", refPrev="A", readPrev="A"),
             Variant(1, 1005, 1006, "C", "G", refPrev="A", readPrev="A") ], vs)


    # Deletions expose that the way we calculate confidences for
    # deletion variants is *broken*.  In the current setup, we have no
    # choice but to pull a confidence out of thin air, or pull it from
    # a nearby base---both incorrect!  The *right* way to do it is to
    # properly compare the two hypotheses, which is possible since we
    # retain the mss/ai.

    # ... here, for now, we are primarily just testing that we don't
    # crash.

    def testDeletionConfidence1(self):
        a = PairwiseAlignment("GATTACA", "GATTAC-")
        qvs = [0, 0, 0, 0, 0, 1]
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000), qvs)
        EQ([ Variant(1, 1006, 1007, "A", "", confidence=1, refPrev="C", readPrev="C") ], vs)

    def testDeletionConfidence2(self):
        a = PairwiseAlignment("GATTACA", "-ATTACA")
        qvs = [1, 0, 0, 0, 0, 0]
        vs = utils.variantsFromAlignment(a, (1, 1000, 2000), qvs)
        EQ([ Variant(1, 1000, 1001, "G", "", confidence=1, refPrev="N", readPrev="N") ], vs)

    def testDeletionConfidence3(self):
        a = PairwiseAlignment("AT", "--")
        qvs = []
        vs =  utils.variantsFromAlignment(a, (1, 1000, 1002), qvs)
        EQ([ Variant(1, 1000, 1002, "AT", "", refPrev="N", readPrev="N") ], vs)
