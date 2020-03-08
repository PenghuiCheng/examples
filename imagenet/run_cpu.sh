#!/bin/sh

CORES=`lscpu | grep Core | awk '{print $4}'`
SOCKETS=`lscpu | grep Socket | awk '{print $2}'`
TOTAL_CORES=`expr $CORES \* $SOCKETS`
num_cores=$TOTAL_CORES
num_threads=$CORES
# KMP_SETTING="KMP_AFFINITY=granularity=fine,compact,1,0"
# KMP_BLOCKTIME=1

# export OMP_NUM_THREADS=$TOTAL_CORES
# export $KMP_SETTING
# export KMP_BLOCKTIME=$KMP_BLOCKTIME

# echo -e "### using OMP_NUM_THREADS=$TOTAL_CORES"
# echo -e "### using $KMP_SETTING"
# echo -e "### using KMP_BLOCKTIME=$KMP_BLOCKTIME\n"

model=mobilenet_v2
batch_sizes="32"
# use_mkldnn=--mkldnn
# pretrained=--pretrained
evaluation=-e
performance_only=--performance
image_path=/lustre/dataset/imagenet/img_raw/
iterations=50
warmup=5
log_level="info"
# profiling=-t
profiling=""
workers=0
# export GLOG_logtostderr=1; export GLOG_v=1000
# export MKLDNN_VERBOSE=1

# export LD_PRELOAD=/opt/intel/compilers_and_libraries_2018.1.163/linux/compiler/lib/intel64_lin/libiomp5.so
# for bs in $batch_sizes; do
for i in $(seq 0 $(($num_cores / $num_threads - 1)))
do
echo $i "instance"
startid=$(($i*$num_threads))
endid=$(($i*$num_threads+$num_threads-1))
export OMP_SCHEDULE=STATIC OMP_DISPLAY_ENV=TRUE OMP_PROC_BIND=TRUE GOMP_CPU_AFFINITY="$startid-$endid"  
export OMP_NUM_THREADS=$num_threads  KMP_AFFINITY=proclist=[$startid-$endid],granularity=fine,explicit
python -u main.py $performance_only $pretrained $evaluation $profiling $use_mkldnn -j $workers -a $model -b $batch_sizes -w $warmup -i $iterations $image_path &
done
# wait
# done