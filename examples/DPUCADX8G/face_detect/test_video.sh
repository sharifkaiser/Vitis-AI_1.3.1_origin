#!/usr/bin/env bash
# Copyright 2019 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


Model_Name=$1
Video_File=$2

SUPPORTED_MODELS="face_detection |face_detection_360_640"

if [[ "$SUPPORTED_MODELS" != *"$Model_Name"* ]]; then
  echo "$Model_Name is an invalid model."
  echo "Valid Models : $SUPPORTED_MODELS."
  echo "Exiting ..."
  exit 1;
fi
if [ -z $Model_Name ];then
    Model_Name=face_detection
    echo -e "Running default model "face_detection_320_320_0.49G".. "
    echo -e "Please provide network name"
fi

# Set Platform Environment Variables
if [ -z $VAI_HOME ]; then
  echo "Please set VAI_HOME, see you next time!"
  exit 1
fi


if [ $Model_Name == "face_detection" ]; then
    NET_H=320
    NET_W=320
else
    NET_H=360
    NET_W=640
fi

# Path to Model-Zoo directory

PROTOTXT=$Model_Name/${Model_Name}.prototxt
CAFFMODEL=$Model_Name/$Model_Name.caffemodel
COMP_DIR=./work
QUANT_DIR=./work

rm -rf $COMP_DIR
mkdir $COMP_DIR
rm -rf $QUANT_DIR
mkdir $QUANT_DIR

NET_DEF=$PROTOTXT
DUMMY_PTXT=$COMP_DIR/${Model_Name}_decent.prototxt
IMGLIST=FDDB/FDDB_list_dummy.txt
CALIB_DATASET=FDDB/

python get_decent_q_prototxt.py ${CAFFE_ROOT}/python/ $NET_DEF  $DUMMY_PTXT $IMGLIST  $CALIB_DATASET
## Run Quantizer
export DECENT_DEBUG=1
#
vai_q_caffe quantize -model $DUMMY_PTXT -weights $CAFFMODEL  -calib_iter 5 -output_dir $QUANT_DIR

if [[ -f $(which vai_c_caffe) ]]; then
  COMPILER=vai_c_caffe
elif [[ -f $VAI_HOME/vai/dpuv1/tools/compile/bin/vai_c_caffe.py ]]; then
  COMPILER=$VAI_HOME/vai/dpuv1/tools/compile/bin/vai_c_caffe.py
else
  echo "Couldn't find the VAI compiler. Exiting ..."
  exit 1
fi

XCLBIN=/opt/xilinx/overlaybins/xdnnv3
if [ -d $XCLBIN ]; then
  echo "--- Using System XCLBIN ---"
else
  echo "--- Using Local XCLBIN ---"
  XCLBIN=${VAI_HOME}/overlaybins/xdnnv3
fi

COMPILER_BASE_OPT=" --prototxt $QUANT_DIR/deploy.prototxt \
      --caffemodel $QUANT_DIR/deploy.caffemodel \
      --arch /opt/vitis_ai/compiler/arch/DPUCADX8G/ALVEO/arch.json \
      --net_name face_detect \
      --output_dir $COMP_DIR"
COMPILER_OTHER_OPT="{"
  COMPILER_OTHER_OPT+=" 'ddr':1024, 'quant_cfgfile': '$QUANT_DIR/quantize_info.txt', "
 COMPILER_OTHER_OPT+="}"


${COMPILER} $COMPILER_BASE_OPT --options "$COMPILER_OTHER_OPT"

## Run on FPGA
VITIS_RUN_DIR=$COMP_DIR

python3 mp_video.py \
	--vitisrundir ${VITIS_RUN_DIR} \
	--videofile ${Video_File}

