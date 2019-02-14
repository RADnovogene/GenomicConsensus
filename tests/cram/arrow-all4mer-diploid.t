Test Arrow diploid polishing

  $ export DATA=$TESTDIR/../data
  $ export INPUT=$DATA/all4mer-diploid/all4merDipl.bam
  $ export REFERENCE=$DATA/all4mer-diploid/all4merDipl.fasta

Run arrow

  $ arrow $INPUT -r $REFERENCE --diploid -o dipl.vcf -o dipl.gff -o cons.fasta

Perfect diploid polishing, found all variants

  $ egrep -v '^##' dipl.vcf
  #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
  all4merDipl	28	.	A	AA,AG	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	71	.	T	C	93	PASS	DP=100;AF=0.5
  all4merDipl	128	.	C	G,T	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	194	.	A	AG,AT	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	247	.	CA	C	93	PASS	DP=100

Ambiguous-free consensus sequence

  $ cat cons.fasta
  >all4merDipl|arrow
  GGGATCCTCTAGAATGCAGGGGCTTATAAACGTGTGAACACCATGTATTTTAAGCCACGC
  ATATCTCTGATTAGATGGAAAAGACAAGTGGGAGAGGCCTTGTTACAGTCCAACTGCACT
  ACCCGCGCGCAGAAGGACTTCGCTCACATCGGATCCCCTAATGCCGGGTTTCCTGGCGAT
  AGTAGGTGCTGTCGAGCGGCAGCTAGCGGTCAATTCTATGACCTCGTTGCGTACTCCGAA
  TCATTGAGCAACCGTCTTTGGTAAATACGAGTTCAGGCAAGCTTGCTGAGGACTAGTAGC
  T

TAG-3610: test that `gffToBed` actually works

  $ gffToBed coverage dipl.gff
  track name=variants description="PacBio: snps, insertions, and deletions derived from consensus calls against reference" useScore=0
  all4merDipl	27	28	meanCov	100.000	.
  all4merDipl	70	71	meanCov	100.000	.
  all4merDipl	127	128	meanCov	100.000	.
  all4merDipl	193	194	meanCov	100.000	.
  all4merDipl	247	248	meanCov	100.000	.
