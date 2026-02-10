#! /usr/bin/env bash
#http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
if [[ $# != 2 ]]; then
        echo $0 input.rds output \(.cloupe suffix will be added\)
        exit 1
fi
input=$1
output=$2
#Because docker bind mounts require absolute paths, this gets tricky
#maybe better to just require the user set an environment variable similar
#to how APPTAINER_BINDDIR works
#this works to get an absolute path because the file should already exist
#path_to_input=$(dirname $(readlink -f $input))
#
path_to_input=$(readlink -f $(dirname $input))
path_to_output=$(readlink -f $(dirname $output))


docker run -v${path_to_input}:${path_to_input} -v${path_to_output}:${path_to_output} louper R -e 'library(loupeR);
library(Seurat);
rds<-readRDS("'$path_to_input/$input'"); 
DefaultAssay(rds)<-"RNA"; 
create_loupe_from_seurat(rds, feature_ids=rownames(rds@assays$RNA), output_name="'$path_to_output/$output'");'
