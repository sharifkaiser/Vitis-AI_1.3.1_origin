/*
 * Copyright 2019 Xilinx Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "./medicaldetection_imp.hpp"

#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <vitis/ai/env_config.hpp>
#include <vitis/ai/profiling.hpp>

using namespace std;
namespace vitis {
namespace ai {

MedicalDetectionImp::MedicalDetectionImp(const std::string& model_name,
                                         bool need_preprocess)
    : vitis::ai::TConfigurableDpuTask<MedicalDetection>(model_name,
                                                        need_preprocess),
      processor_{vitis::ai::MedicalDetectionPostProcess::create(
          configurable_dpu_task_->getInputTensor()[0],
          configurable_dpu_task_->getOutputTensor()[0],
          configurable_dpu_task_->getConfig())} {}

MedicalDetectionImp::~MedicalDetectionImp() {}

MedicalDetectionResult MedicalDetectionImp::run(const cv::Mat& input_img) {
  cv::Mat img;
  auto size = cv::Size(getInputWidth(), getInputHeight());

  if (size != input_img.size()) {
    cv::resize(input_img, img, size, 0, 0, cv::INTER_LINEAR);
  } else {
    img = input_img;
  }
  __TIC__(DET_total)
  __TIC__(DET_setimg)

  // tensorflow but need BGR
  configurable_dpu_task_->setInputImageBGR(img);

  __TOC__(DET_setimg)
  __TIC__(DET_dpu)
  configurable_dpu_task_->run(0);
  __TOC__(DET_dpu)

  __TIC__(DET_post)
  auto results = processor_->medicaldetection_post_process(0);
  __TOC__(DET_post)

  __TOC__(DET_total)
  return results;
}

std::vector<MedicalDetectionResult> MedicalDetectionImp::run(
    const std::vector<cv::Mat>& input_img) {
  auto size = cv::Size(getInputWidth(), getInputHeight());
  auto batch_size = input_img.size();

  std::vector<cv::Mat> vimg(batch_size);

  for (auto i = 0ul; i < batch_size; i++) {
    if (size != input_img[i].size()) {
      cv::resize(input_img[i], vimg[i], size, 0, 0, cv::INTER_LINEAR);
    } else {
      vimg[i] = input_img[i];
    }
  }
  __TIC__(DET_total)
  __TIC__(DET_setimg)

  configurable_dpu_task_->setInputImageBGR(vimg);

  __TOC__(DET_setimg)
  __TIC__(DET_dpu)
  configurable_dpu_task_->run(0);
  __TOC__(DET_dpu)

  __TIC__(DET_post)
  auto results = processor_->medicaldetection_post_process();
  __TOC__(DET_post)

  __TOC__(DET_total)
  return results;
}

}  // namespace ai
}  // namespace vitis
