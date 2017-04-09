#!/bin/bash

# Script adapted from http://feedback.datalogics.com/knowledgebase/articles/821196-building-openssl-and-curl-for-ios-64-bit-platform
#
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

# This script builds a static version of
# curl ${CURL_VERSION} for iOS 7.1 that contains code for
# arm64, armv7, arm7s, i386 and x86_64.

# Setup paths to stuff we need

CURL_SOURCE_DIRECTORY=$1
OUTPUT_DIRECTORY=$2
BUILD_DIRECTORY=$3
CURL_TEMPORARY_SOURCE_DIRECTORY=${BUILD_DIRECTORY}/curl_source

DEVELOPER="/Applications/Xcode.app/Contents/Developer"

SDK_VERSION=""
MIN_VERSION="10.2"

IPHONEOS_PLATFORM="${DEVELOPER}/Platforms/iPhoneOS.platform"
IPHONEOS_SDK="${IPHONEOS_PLATFORM}/Developer/SDKs/iPhoneOS${SDK_VERSION}.sdk"
IPHONEOS_GCC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"

IPHONESIMULATOR_PLATFORM="${DEVELOPER}/Platforms/iPhoneSimulator.platform"
IPHONESIMULATOR_SDK="${IPHONESIMULATOR_PLATFORM}/Developer/SDKs/iPhoneSimulator${SDK_VERSION}.sdk"
IPHONESIMULATOR_GCC="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang"

# Make sure things actually exist

if [ ! -d "$IPHONEOS_PLATFORM" ]; then
    echo "Cannot find $IPHONEOS_PLATFORM"
    exit 1
fi

if [ ! -d "$IPHONEOS_SDK" ]; then
    echo "Cannot find $IPHONEOS_SDK"
    exit 1
fi

if [ ! -x "$IPHONEOS_GCC" ]; then
    echo "Cannot find $IPHONEOS_GCC"
    exit 1
fi
if [ ! -d "$IPHONESIMULATOR_PLATFORM" ]; then
    echo "Cannot find $IPHONESIMULATOR_PLATFORM"
    exit 1
fi

if [ ! -d "$IPHONESIMULATOR_SDK" ]; then
    echo "Cannot find $IPHONESIMULATOR_SDK"
    exit 1
fi

if [ ! -x "$IPHONESIMULATOR_GCC" ]; then
    echo "Cannot find $IPHONESIMULATOR_GCC"
    exit 1
fi

# Clean up whatever was left from our previous build

rm -rf ${OUTPUT_DIRECTORY}/lib ${OUTPUT_DIRECTORY}/include-32 ${OUTPUT_DIRECTORY}/include-64
rm -rf ${BUILD_DIRECTORY}/curl-*
rm -rf ${BUILD_DIRECTORY}/curl-*.*-log

build()
{
    HOST=$1
    ARCH=$2
    GCC=$3
    SDK=$4
    MOREFLAGS=$5
    rm -rf ${CURL_TEMPORARY_SOURCE_DIRECTORY}
    cp -r "${CURL_SOURCE_DIRECTORY}" ${CURL_TEMPORARY_SOURCE_DIRECTORY}
    pushd . > /dev/null
    cd ${CURL_TEMPORARY_SOURCE_DIRECTORY}
    export IPHONEOS_DEPLOYMENT_TARGET=${MIN_VERSION}
    export CC=${GCC}
    export CFLAGS="-arch ${ARCH} -pipe -Os -gdwarf-2 -isysroot ${SDK} -fembed-bitcode"
    export CPPFLAGS=${MOREFLAGS}
    export LDFLAGS="-arch ${ARCH} -isysroot ${SDK}"
    ./configure --disable-shared --enable-static --host=${HOST} --with-darwinssl --prefix="${BUILD_DIRECTORY}/curl-${ARCH}" &> "${BUILD_DIRECTORY}/curl-${ARCH}.log"
    make -j `sysctl -n hw.logicalcpu_max` &> "${BUILD_DIRECTORY}/curl-${ARCH}.build-log"
    make install &> "${BUILD_DIRECTORY}/curl-${ARCH}.install-log"
    popd > /dev/null
    rm -rf ${CURL_TEMPORARY_SOURCE_DIRECTORY}
}

build "armv7-apple-darwin"  "armv7"  "${IPHONEOS_GCC}"        "${IPHONEOS_SDK}" ""
build "armv7s-apple-darwin" "armv7s" "${IPHONEOS_GCC}"        "${IPHONEOS_SDK}" ""
build "arm-apple-darwin"    "arm64"  "${IPHONEOS_GCC}"        "${IPHONEOS_SDK}" ""
build "i386-apple-darwin"   "i386"   "${IPHONESIMULATOR_GCC}" "${IPHONESIMULATOR_SDK}" "-D__IPHONE_OS_VERSION_MIN_REQUIRED=${IPHONEOS_DEPLOYMENT_TARGET%%.*}0000"
build "x86_64-apple-darwin" "x86_64" "${IPHONESIMULATOR_GCC}" "${IPHONESIMULATOR_SDK}" "-D__IPHONE_OS_VERSION_MIN_REQUIRED=${IPHONEOS_DEPLOYMENT_TARGET%%.*}0000"

#

mkdir -p ${OUTPUT_DIRECTORY}/lib ${OUTPUT_DIRECTORY}/include-32 ${OUTPUT_DIRECTORY}/include-64
cp -r ${BUILD_DIRECTORY}/curl-i386/include/curl ${OUTPUT_DIRECTORY}/include-32/
cp -r ${BUILD_DIRECTORY}/curl-x86_64/include/curl ${OUTPUT_DIRECTORY}/include-64/
lipo \
    "${BUILD_DIRECTORY}/curl-armv7/lib/libcurl.a" \
    "${BUILD_DIRECTORY}/curl-armv7s/lib/libcurl.a" \
    "${BUILD_DIRECTORY}/curl-arm64/lib/libcurl.a" \
    "${BUILD_DIRECTORY}/curl-i386/lib/libcurl.a" \
    "${BUILD_DIRECTORY}/curl-x86_64/lib/libcurl.a" \
    -create -output ${OUTPUT_DIRECTORY}/lib/libcurl.a
RESULT=$?

rm -rf "${BUILD_DIRECTORY}/curl-*"
rm -rf "${BUILD_DIRECTORY}/curl-*.*-log"

exit $RESULT
