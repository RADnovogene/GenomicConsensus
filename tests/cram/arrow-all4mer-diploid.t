Test Arrow diploid polishing

  $ export DATA=$TESTDIR/../data
  $ export INPUT=$DATA/all4mer-diploid/all4merDipl.bam
  $ export REFERENCE=$DATA/all4mer-diploid/all4merDipl.fasta

Run arrow

  $ arrow $INPUT -r $REFERENCE --diploid -o dipl.vcf

Perfect diploid polishing, found all variants

  $ egrep -v '^##' dipl.vcf
  #CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
  all4merDipl	28	.	A	AA,AG	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	71	.	T	C,T	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	128	.	C	G,T	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	194	.	A	AG,AT	93	PASS	DP=100;AF=0.5,0.5
  all4merDipl	247	.	CA	C	93	PASS	DP=100
