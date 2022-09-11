#!/bin/bash

source /opt/intel/oneapi/setvars.sh
python3 ./EMBuild_v1.0/mcp/mcp-predict.py -i $1 -o /data/out_map -m ./EMBuild_v1.0/mcp/model_state_dict
