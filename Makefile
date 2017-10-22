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

export KITURA_IOS_BUILD_SCRIPTS_DIR=Builder/Scripts
-include Builder/Makefile

ifeq ($(SWIFT_SNAPSHOT), swift-3.1.1)
OS=10.3.1
DEVICE=iPhone 7
else
OS=11.0
DEVICE=iPhone 8
endif

Builder/Makefile:
	@echo --- Fetching submodules
	git submodule init
	git submodule update --remote --merge

test: Builder/Makefile prepareXcode
	echo SWIFT_SNAPSHOT=${SWIFT_SNAPSHOT}
	ruby Builder/Scripts/set_deployment_version.rb ClientSide/ClientSide.xcodeproj ${OS}
	xcodebuild test -workspace EndToEnd.xcworkspace -scheme ClientSide \
                -destination 'platform=iOS Simulator,OS=${OS},name=${DEVICE}'
