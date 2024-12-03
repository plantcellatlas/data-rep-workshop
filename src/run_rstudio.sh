#!/bin/bash
# specify path to container

renv="rocker/rstudio:4.4"
service="docker"

while getopts ":t:s:" opt; do
  case $opt in
    t) renv="$OPTARG"
    ;;
    c) service="$OPTARG"
    ;;
  esac

done

if [ $service == "docker" ]; then
	docker run --rm -p 8787:8787 --mount type=bind,source="$(pwd)"/,target=/home/rstudio/ $renv 
elif [ $service == "apptainer" ]; then
	TMPDIR=~/rstudio-tmp
	rm -Rf $TMPDIR
	
	mkdir -p $TMPDIR/tmp/rstudio-server
	
	mkdir -p $TMPDIR/var/lib
	mkdir -p $TMPDIR/var/run
       	
	apptainer exec -B $TMPDIR/var/lib:/var/lib/rstudio-server -B $TMPDIR/var/run:/var/run/rstudio-server -B $TMPDIR/tmp:/tmp $renv rserver --www-port 8789 --server-user $USER 
fi

