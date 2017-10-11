#!/usr/bin/env bash

#SBATCH --job-name=audioset-dl-array
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=12GB
#SBATCH --time=7-0
#SBATCH --mail-type=ALL
##SBATCH --mail-user=joe.schmoe@real.email
#SBATCH --output="audioset-dl-%A-%a.out"
#SBATCH --err="audioset-dl-%A-%a.err"

SRCDIR=$HOME/audiosetdl
FFMPEG_PATH=$SRCDIR/bin/ffmpeg/ffmpeg
DATADIR=$SRCDIR/audioset
mkdir -p $DATADIR

module purge

source $SRCDIR/bin/miniconda/bin/activate

EVAL_PATH="$DATADIR/eval_segments.csv.$(printf '%02d' $SLURM_ARRAY_TASK_ID)";
BALANCED_TRAIN_PATH="$DATADIR/balanced_train_segments.csv.$(printf '%02d' $SLURM_ARRAY_TASK_ID)";
UNBALANCED_TRAIN_PATH="$DATADIR/unbalanced_train_segments.csv.$(printf '%02d' $SLURM_ARRAY_TASK_ID)";

python $SRCDIR/download_audioset.py \
    -f $FFMPEG_PATH \
    --eval $EVAL_PATH \
    --balanced-train $BALANCED_TRAIN_PATH \
    --unbalanced-train $UNBALANCED_TRAIN_PATH \
    --audio-codec flac \
    --audio-format flac \
    --audio-sample-rate 48000 \
    --audio-bit-depth 16 \
    --video-codec h264 \
    --video-format mp4 \
    --video-frame-rate 30 \
    --video-mode bestvideoaudio \
    --num-workers 8 \
    --num-retries 10 \
    --no-logging \
    --verbose \
    $DATADIR
