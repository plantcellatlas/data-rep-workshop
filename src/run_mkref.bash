#!/bin/bash
set -euo pipefail
genome_name=$1
genome_fasta=$2
genome_gtf=$3
cellranger mkref --genome $genome_name --fasta $genome_fasta --genes $genome_gtf
