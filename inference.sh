#!/bin/bash
#SBATCH --job-name=alien-barley-inference
#SBATCH --account=project_2005430
#SBATCH --partition=gputest
#SBATCH --time=00:15:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:a100:1,nvme:50

module load pytorch
#source venv/bin/activate
tar -xf /scratch/project_2005430/ruastefa/datasets/alien-barley-2-train.tar -C $LOCAL_SCRATCH
tar -xf /scratch/project_2005430/ruastefa/yolov7/yolo-labels-2.tar -C $LOCAL_SCRATCH

awk -v tmpdir=$LOCAL_SCRATCH '{ print tmpdir"/"$1 }' train_imgs.txt > train_imgs_local.txt
awk -v tmpdir=$LOCAL_SCRATCH '{ print tmpdir"/"$1 }' val_imgs.txt > val_imgs_local.txt
awk -v tmpdir=$LOCAL_SCRATCH '{ print tmpdir"/"$1 }' val_imgs.txt > test_imgs_local.txt

mkdir $LOCAL_SCRATCH/images $LOCAL_SCRATCH/labels
mv $LOCAL_SCRATCH/alien-barley-2-train/train_labeled/* $LOCAL_SCRATCH/images/
mv $LOCAL_SCRATCH/yolo-labels-2/train/* $LOCAL_SCRATCH/yolo-labels-2/val/* $LOCAL_SCRATCH/labels/
rm *.cache

python detect.py --weights runs/train/yolov7-w69/weights/last.pt --conf-thres 0.1 --img-size 1280 --source $LOCAL_SCRATCH/images/ --save-txt
