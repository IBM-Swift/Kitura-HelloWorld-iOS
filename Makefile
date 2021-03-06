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
# initial "-" prevents initial error message, when Builder submodule is not yet fetched
-include Builder/Makefile

DEPLOYMENT_OS=12.1
SIMULATOR_OS=12.1
DEVICE=iPhone X

Builder/Makefile:
	@echo --- Fetching submodules
	git submodule init
	git submodule update --remote --merge
	make setDeploymentVersionOfSharedServerClient

setDeploymentVersionOfSharedServerClient:
	ruby Builder/Scripts/set_deployment_version.rb SharedServerClient/SharedServerClient.xcodeproj ${DEPLOYMENT_OS}

test: Builder/Makefile ServerSide/Package.swift prepareXcode \
 setDeploymentVersionOfSharedServerClient
	echo SWIFT_SNAPSHOT=${SWIFT_SNAPSHOT}
	xcodebuild test -workspace EndToEnd.xcworkspace -scheme ClientSide \
                -destination 'platform=iOS Simulator,OS=${SIMULATOR_OS},name=${DEVICE}'
