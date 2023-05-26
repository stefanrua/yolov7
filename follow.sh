#!/bin/bash
last=$(ls slurm-*.out -v | tail -1)
tail -f $last
