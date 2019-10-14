# (C) Copyright IBM Corp. 2018, 2019. All Rights Reserved.
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

#!/bin/bash

set -vex

ln -s ${GXX} ${PREFIX}/bin/g++
ln -s ${GCC} ${PREFIX}/bin/gcc
rm -rf build
mkdir build && cd build
cmake -DBLAS=open -DUSE_CUDA=1 -DCUDA_LIBRARY_PATH="${PREFIX}/lib" -DUSE_MKL_IF_AVAILABLE=OFF -DUSE_CUDNN=1 -DUSE_CXX14_IF_AVAILABLE=1 -GNinja ..
ninja -v -j 4

rm -rf ${PREFIX}/include
cp -rf lib/libmxnet.so ${PREFIX}/lib
mkdir ${PREFIX}/include
cp -rf include/mxnet ${PREFIX}/include
cp -rf $(readlink -f include/dlpack) ${PREFIX}/include
cp -rf $(readlink -f include/dmlc) ${PREFIX}/include
cp -rf $(readlink -f include/mshadow) ${PREFIX}/include
cp -rf $(readlink -f include/nnvm) ${PREFIX}/include

cd python
${PYTHON} setup.py install
