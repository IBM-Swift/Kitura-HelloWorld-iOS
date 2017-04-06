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

ifndef KITURA_IOS_BUILD_SCRIPTS_DIR
KITURA_IOS_BUILD_SCRIPTS_DIR = Scripts
endif

all: openXcode

openXcodeAll: iOSStaticLibraries/Curl ServerSide
	@echo --- Generating ServerSide Xcode project
	cd ServerSide && swift package generate-xcodeproj
	@echo ——- Fixing ServerSide Xcode project
	-${KITURA_IOS_BUILD_SCRIPTS_DIR}/fixServerSideXcodeProject.sh ${NUMBER_OF_BITS}
	@echo ——- Creating EndToEnd Xcode workspace
	rm -rf EndToEnd.xcworkspace
	-ruby ${KITURA_IOS_BUILD_SCRIPTS_DIR}/create_xcode_workspace.rb ClientSide/*.xcodeproj ServerSide/*.xcodeproj
	@echo --- Opening EndToEnd workspace
	open EndToEnd.xcworkspace

openXcode32:
	make NUMBER_OF_BITS="32" openXcodeAll

openXcode:
	make NUMBER_OF_BITS="64" openXcodeAll

ServerSide:
	@echo --- Fetching submodules
	git submodule init
	git submodule update --remote --merge

iOSStaticLibraries/Curl:
	@echo "Please download a curl source, uncompress it and run Builder/Scripts/buildCurlStaticLibrary.sh <the uncompressed curl directory>"
	@echo "You can download curl source from https://curl.haxx.se/download/"
	exit 1

.PHONY: openXcode
