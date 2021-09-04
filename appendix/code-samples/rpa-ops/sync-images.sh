#!/bin/bash

if [ ! -n "$1" ]; then
    echo "USAGE: sync-images TAR_FILE_NAME"
    exit 0
else
    tarfile="$1"
fi

for h in 31 32 33 34 35 36; do 
    scp $tarfile root@10.10.0.$h:/tmp;
    ssh root@10.10.0.$h "cd /tmp; docker load < $tarfile";
done
