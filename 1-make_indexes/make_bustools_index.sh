#!/bin/bash -x

### Set up working environment

FASTA=/Volumes/Bf110/ct5/refseq/gencode/GRCh38.p13.genome.fa
GTF=/Volumes/Bf110/ct5/refseq/gencode/gencode.v39.annotation.gtf
CPU=3

### Create normal mapping index

mkdir refseq

cd refseq

mkdir gencode_human_bustools-velocyto

cd gencode_human_bustools-velocyto

kb ref -i gencode_grch38.idx -g t2g.txt -f1 cdna.fa -f2 intron.fa -c1 cdna_t2c.txt -c2 intron_t2c.txt --workflow lamanno -n 8 $FASTA $GTF

cd ..

mkdir gencode_human_bustools

cd gencode_human_bustools

kb ref -i transcriptome.idx -g transcripts_to_genes.txt -f1 cdna.fa $FASTA $GTF

cd ../..



