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
$CXX -std=c++17 -I. -o test_accuracy_retinaface test_accuracy_retinaface.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-retinaface  -lvitis_ai_library-model_config -lvitis_ai_library-math -lglog 
$CXX -std=c++17 -I. -o test_jpeg_retinaface test_jpeg_retinaface.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-retinaface  -pthread -lglog 
$CXX -std=c++17 -I. -o test_performance_retinaface test_performance_retinaface.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-retinaface  -lvart-util -lvitis_ai_library-dpu_task -pthread -lglog 
$CXX -std=c++17 -I. -o test_video_retinaface test_video_retinaface.cpp -lopencv_core -lopencv_video -lopencv_videoio -lopencv_imgproc -lopencv_imgcodecs -lopencv_highgui -lvitis_ai_library-retinaface  -pthread -lglog 
