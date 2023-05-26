#!/bin/bash
#SBATCH --job-name=alien-barley-train
#SBATCH --account=project_2005430
#SBATCH --partition=gpusmall
#SBATCH --time=15:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:a100:1,nvme:50

module load pytorch
tar -xf /scratch/project_2005430/ruastefa/datasets/alien-barley-1-yolo.tar -C $LOCAL_SCRATCH
mv $LOCAL_SCRATCH/alien-barley-1-yolo/* $LOCAL_SCRATCH

awk -v tmpdir=$LOCAL_SCRATCH '{ print tmpdir"/"$1 }' $LOCAL_SCRATCH/train_imgs.txt > train_imgs_local.txt
awk -v tmpdir=$LOCAL_SCRATCH '{ print tmpdir"/"$1 }' $LOCAL_SCRATCH/val_imgs.txt > val_imgs_local.txt
awk -v tmpdir=$LOCAL_SCRATCH '{ print tmpdir"/"$1 }' $LOCAL_SCRATCH/test_imgs.txt > test_imgs_local.txt

rm *.cache

python train_aux.py --device 0 --batch-size 16 --data data/barley.yaml --img 1280 1280 --cfg cfg/training/yolov7-w6.yaml --weights '' --name w6 --hyp data/hyp.scratch.p6.yaml
