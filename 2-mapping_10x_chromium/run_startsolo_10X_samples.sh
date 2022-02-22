#!/bin/bash -x

### Set up working environment

CPU=3
WL=/Volumes/Bf110/ct5/refseq/10x_chromium/737K-august-2016.txt
REFSEQ=/Volumes/Bf110/ct5/refseq/gencode
READS=/Volumes/TIGERII/nobackup/raw_data/single_cell/lung/Cai_TB_2022/HRA000910/

### Define mapping loop

for i in $(cat samples.txt)

do

    STAR --genomeDir $REFSEQ --runThreadN $CPU --readFilesIn <(gunzip -c $READS/$i/$i\_r2.fq.gz) <(gunzip -c $READS/$i/$i\_f1.fq.gz) --soloCellFilter EmptyDrops_CR --outSAMtype BAM SortedByCoordinate --soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts --soloUMIfiltering MultiGeneUMI_CR --soloUMIdedup 1MM_CR --soloBarcodeMate 1 --clip5pNbases 39 0 --soloCBstart 1 --soloCBlen 16 --soloUMIstart 17 --soloUMIlen 10 --soloType CB_UMI_Simple --soloCBwhitelist $WL

done

