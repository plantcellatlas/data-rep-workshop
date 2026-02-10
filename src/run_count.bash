#!/bin/bash
set -euo pipefail
sample_id=$1
fastq_dir=$2
#cellranger is fussy about fastq file naming, and our files from SRA fasterq-dump need to have their names munged a bit
#probably would make more sense as a separate script...
mkdir -p $fastq_dir/$sample_id
pushd $fastq_dir/$sample_id
for f in ../*$sample_id*.fq.gz; do
  target_name=$(basename $f | sed 's/\.\(R[12]\)\.fq/_S1_L001_\1_001.fastq/')
  if [[ ! -e $target_name ]]; then
    ln -s $f $target_name
  fi
done
popd

cellranger count --id $sample_id --transcriptome workshop_genome --fastqs $fastq_dir/$sample_id --create-bam true --chemistry ARC-v1
