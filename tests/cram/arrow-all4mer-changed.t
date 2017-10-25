Bite-sized quiver test using an All4Mers template!

  $ export DATA=$TESTDIR/../data
  $ export INPUT=$DATA/all4mer-changed/out.aligned_subreads.bam
  $ export REFERENCE=$DATA/all4mer-changed/All4mer.V2.01_Insert-changed.fa

Run arrow.

  $ arrow $INPUT -r $REFERENCE -o v.gff -o css.fa -o css.fq

No variants!

  $ egrep -v '^#' v.gff | cat
  All4mer.V2.01_Insert-changed\t.\tinsertion\t11\t11\t.\t.\t.\treference=.;variantSeq=A;coverage=100;confidence=93 (esc)
  All4mer.V2.01_Insert-changed\t.\tsubstitution\t51\t51\t.\t.\t.\treference=A;variantSeq=G;coverage=100;confidence=93 (esc)
  All4mer.V2.01_Insert-changed\t.\tdeletion\t124\t124\t.\t.\t.\treference=C;variantSeq=.;coverage=100;confidence=93 (esc)
  All4mer.V2.01_Insert-changed\t.\tsubstitution\t230\t230\t.\t.\t.\treference=G;variantSeq=C;coverage=100;confidence=93 (esc)

Perfect consensus, no no-calls

  $ cat css.fa
  >All4mer.V2.01_Insert-changed|arrow
  CATCAGGTAAGAAAGTACGATGCTACAGCTTGTGACTGGTGCGGCACTTTTGGCTGAGTT
  TCCTGTCCACCTCATGTATTCTGCCCTAACGTCGGTCTTCACGCCATTACTAGACCGACA
  AAATGGAAGCCGGGGCCTTAAACCCCGTTCGAGGCGTAGCAAGGAGATAGGGTTATGAAC
  TCTCCCAGTCAATATACCAACACATCGTGGGACGGATTGCAGAGCGAATCTATCCGCGCT
  CGCATAATTTAGTGTTGATC

  $ fold -60 css.fq
  @All4mer.V2.01_Insert-changed|arrow
  CATCAGGTAAGAAAGTACGATGCTACAGCTTGTGACTGGTGCGGCACTTTTGGCTGAGTT
  TCCTGTCCACCTCATGTATTCTGCCCTAACGTCGGTCTTCACGCCATTACTAGACCGACA
  AAATGGAAGCCGGGGCCTTAAACCCCGTTCGAGGCGTAGCAAGGAGATAGGGTTATGAAC
  TCTCCCAGTCAATATACCAACACATCGTGGGACGGATTGCAGAGCGAATCTATCCGCGCT
  CGCATAATTTAGTGTTGATC
  +
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~~~~~~~~~~~~~~~~~~~~

