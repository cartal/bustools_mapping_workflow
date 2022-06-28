#!/bin/bash -x

### Set up working environment

CPU=8
RAM=12G
IDX=/Volumes/Bf110/ct5/refseq/bustools/transcriptome.idx
T2G=/Volumes/Bf110/ct5/refseq/bustools/transcripts_to_genes.txt
READS= <Folder where reads are located>
OUT= <Folder where output files should be saved>

### Define mapping loop

for i in $(cat samples.txt)

do

    kb count -i $IDX -g $T2G -x BULK --parity paired -t $CPU -m $RAM -o $i\_bulk $READS/$i/$i\_1.fastq $READS/$i/$i\_2.fastq

    mv $i\_bulk $OUT

    rm -r $i
    
done

