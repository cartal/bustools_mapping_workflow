#!/bin/bash -x

### Set up working environment

CPU=5
RAM=14G
WL=/Volumes/Bf110/ct5/refseq/10x_chromium/737K-august-2016.txt
IDX=/Volumes/Bf110/ct5/refseq/bustools/transcriptome.idx
T2G=/Volumes/Bf110/ct5/refseq/bustools/transcripts_to_genes.txt
READS=/Volumes/Bf110/ct5/raw_data/lung/TB/Cai2021/

### Define mapping loop

for i in $(cat samples.txt)

do

    fasterq-dump --split-3 --threads $CPU --progress $i -O $i

    kb count -i $IDX -g $T2G -x 10xv2 --h5ad -t $CPU -m $RAM -w $WL --filter bustools -o $i\_Cai2021 $READS/$i/$i\_1.fastq $READS/$i/$i\_2.fastq

    rm -r $i
    
done

