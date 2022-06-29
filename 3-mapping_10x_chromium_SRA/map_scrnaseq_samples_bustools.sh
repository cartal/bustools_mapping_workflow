#!/bin/bash -x

### Set up working environment

WL=/home/cartalop/data/refseq/10xgenomics/737K-august-2016.txt
CPU=14
RAM=8G
TECH=10XV2
INDEX=/home/cartalop/data/refseq/gencode/human/index/bustools/gencode_GRCh38.p13.idx
T2G=/home/cartalop/data/refseq/gencode/human/index/bustools/gencode_GRCh38.p13.t2g
SRATOOLS=/home/cartalop/tools/sratoolkit.3.0.0-centos_linux64/bin/


###Download and map samples individually

for i in $(cat SRR_Acc_List.txt)

do

    $SRATOOLS/fasterq-dump $i --split-files -e $CPU -p --include-technical

    pigz -p $CPU -c $i\_2.fastq > $i\_2.fastq.gz 
    pigz -p $CPU -c $i\_3.fastq > $i\_3.fastq.gz

    rm $i\_1.fastq $i\_2.fastq

    kb count -t $CPU -m $RAM -i $INDEX -g $T2G -x $TECH -w $WL --h5ad -o $i --filter bustools $i\_2.fastq.gz $i\_3.fastq.gz

    sshpass -p '@JunoX110616' rsync -rahP -e ssh $i\_2.fastq.gz $i\_3.fastq.gz carlos.lopez@clara:/home/icb/carlos.lopez/storage/datasets/single_cell/pbmcs/GSE196735/reads/

    sshpass -p '@JunoX110616' rsync -rahP -e ssh $i carlos.lopez@clara:/home/icb/carlos.lopez/storage/datasets/single_cell/pbmcs/GSE196735/samples/

    rm -r *.fastq.gz *.fastq $i 

done

