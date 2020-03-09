# install dependency package
1. Pytorch 
Repo: ssh://git@gitlab.devtools.intel.com:29418/pytorch-cpu/pytorch_aten_integration.git
branch: pytorch-1.4
version:3bad11c5948b3d570562e3f1839487de9c4f5ac8
build and install:
```
git submodule update --init --recursive
python setup.py install --user
```
2. torchvision
```
conda install torchvision>=0.5.0
```

# dataset
dataset: imagenet 

# run benchmark and profiling: cd training/object_detection/
```
./run_cpu.sh
```
## in run_cpu.sh, you can modify the parameters :
### 
### model=mobilenet_v2                              //model name
### batch_sizes="128"
### use_mkldnn=--mkldnn
### pretrained=--pretrained                        //use pretrained model weights
### evaluation=-e                                  //inference only
### performance_only=--performance                 //test perormance only
### image_path=/lustre/dataset/imagenet/img_raw/   //dataset path
### iterations=100                                 //totle iteraions to run
### warmup=50                                      //warmup number to prerun
### log_level="info"                               //log
### workers=1                                      //number of data loading workers