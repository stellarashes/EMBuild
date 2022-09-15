#!/bin/bash
ulimit -s 1048576
source /opt/intel/oneapi/setvars.sh
mkdir -p /data/out

python3 ./mcp/mcp-predict.py -i /data/$1 -o /data/out/out_map -m ./mcp/model_state_dict

for i in /data/*.pdb; do
    DIR=`dirname $i`
    NAME=`basename $i`
    ./SWORD -i $i -m 15 -v > /data/out/$NAME.out
    ./asgdom $i /data/out/$NAME.out /data/out/$NAME.doms.pdb
done

cat /data/out/*.doms.pdb > /data/out/init_chains.pdb

./EMBuild /data/out/out_map /data/out/init_chains.pdb 4.0 /data/out/EMBuild.pdb
./rearrangepdb /data/out/EMBuild.pdb /data/out/EMBuild_rearranged.pdb
./EMBuild /data/out/out_map /data/out/EMBuild_rearranged.pdb 4.0 /data/out/EMBuild_scored.pdb --score -stride ./stride/stride
