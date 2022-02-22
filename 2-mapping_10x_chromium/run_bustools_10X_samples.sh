#!/bin/bash -x

### Set up working environment

CPU=3
RAM=12G
WL=/Volumes/Bf110/ct5/refseq/10x_chromium/737K-august-2016.txt
IDX=/Volumes/Bf110/ct5/refseq/bustools/transcriptome.idx
T2G=/Volumes/Bf110/ct5/refseq/bustools/transcripts_to_genes.txt
READS=/Volumes/TIGERII/nobackup/raw_data/single_cell/lung/Cai_TB_2022/HRA000910

### Define mapping loop

for i in $(cat samples.txt)

do

    kb count -i $IDX -g $T2G -x 10xv2 --h5ad -t $CPU -m $RAM -w $WL --filter bustools -o $i $READS/$i/$i\_f1.fq.gz $READS/$i/$i\_r2.fq.gz
    
done

