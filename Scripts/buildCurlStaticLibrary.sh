#!/bin/bash

# Copyright IBM Corporation 2017
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

CURL_SOURCE_DIRECTORY=$1

if [ "$#" -ne 1 ]; then
    echo "Please provide a curl source directory. You can download it from https://curl.haxx.se/download/"
    exit 1
fi

if [ ! -d "$CURL_SOURCE_DIRECTORY" ]; then
    echo "Cannot find $CURL_SOURCE_DIRECTORY"
    exit 1
fi

OUTPUT_DIRECTORY="$(pwd)/iOSStaticLibraries/Curl"
BUILD_DIRECTORY="${OUTPUT_DIRECTORY}/.build"
rm -rf ${OUTPUT_DIRECTORY}
mkdir -p ${BUILD_DIRECTORY}
mkdir -p ${OUTPUT_DIRECTORY}
Builder/Scripts/doBuildCurl.sh $CURL_SOURCE_DIRECTORY ${OUTPUT_DIRECTORY} ${BUILD_DIRECTORY}
if [ $? -ne 0 ]; then
    rm -rf ${OUTPUT_DIRECTORY};
    echo "ERROR: Building ${OUTPUT_DIRECTORY} failed."
    echo "Try curl version 7.43.0 from https://curl.haxx.se/download/ - it worked for us."
    exit 1
fi

rm -rf ${OUTPUT_DIRECTORY}/include
rm -rf ${BUILD_DIRECTORY}
echo "Succussfully built ${OUTPUT_DIRECTORY}. Now you can run make openXcode"
