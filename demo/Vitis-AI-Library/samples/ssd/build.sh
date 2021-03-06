#
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
#

CXX=${CXX:-g++}
$CXX -std=c++17 -I. -o test_accuracy_mlperf_ssd_resnet34_tf test_accuracy_mlperf_ssd_resnet34_tf.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -lvitis_ai_library-model_config -ljson-c -lvitis_ai_library-math -lvitis_ai_library-dpu_task -lglog 
$CXX -std=c++17 -I. -o test_accuracy_ssd_adas_pruned_0_95 test_accuracy_ssd_adas_pruned_0_95.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -lvitis_ai_library-model_config -lvitis_ai_library-math -lvitis_ai_library-dpu_task -lglog 
$CXX -std=c++17 -I. -o test_accuracy_ssd_mobilenet_v2 test_accuracy_ssd_mobilenet_v2.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -lvitis_ai_library-model_config -lvitis_ai_library-math -lvitis_ai_library-dpu_task -lglog 
$CXX -std=c++17 -I. -o test_accuracy_ssd_pedestrian_pruned_0_97 test_accuracy_ssd_pedestrian_pruned_0_97.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -lvitis_ai_library-model_config -lvitis_ai_library-math -lvitis_ai_library-dpu_task -lglog 
$CXX -std=c++17 -I. -o test_accuracy_ssd_traffic_pruned_0_9 test_accuracy_ssd_traffic_pruned_0_9.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -lvitis_ai_library-model_config -lvitis_ai_library-math -lvitis_ai_library-dpu_task -lglog 
$CXX -std=c++17 -I. -o test_jpeg_ssd test_jpeg_ssd.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -pthread -lglog 
$CXX -std=c++17 -I. -o test_performance_ssd test_performance_ssd.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd  -lvart-util -lvitis_ai_library-dpu_task -pthread -lglog 
$CXX -std=c++17 -I. -o test_video_ssd test_video_ssd.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-ssd -pthread -lglog 
