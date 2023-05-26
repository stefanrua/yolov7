#!/bin/bash
#SBATCH --job-name=alien-barley-detect
#SBATCH --account=project_2005430
#SBATCH --partition=gpusmall
#SBATCH --time=10:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:a100:1,nvme:50

module load pytorch
tar -xf /scratch/project_2005430/ruastefa/datasets/inference/ilmajoki1.tar -C $LOCAL_SCRATCH
mv $LOCAL_SCRATCH/ilmajoki1/images-cut $LOCAL_SCRATCH/images

rm *.cache

python detect.py --nosave --save-conf --save-txt --device 0 --source $LOCAL_SCRATCH/images --img-size 1280 --weights runs/train/yolov7-w615/weights/best.pt
