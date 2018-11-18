![Kitura Builder for iOS](https://raw.githubusercontent.com/IBM-Swift/Kitura-Builder-iOS/master/Documentation/KituraIOS.jpg)

# Kitura/iOS Hello World
[![Build Status](https://travis-ci.org/IBM-Swift/Kitura-HelloWorld-iOS.svg?branch=master)](https://travis-ci.org/IBM-Swift/Kitura-HelloWorld-iOS)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![iOS](https://img.shields.io/badge/os-iOS-red.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)
[![codebeat badge](https://codebeat.co/badges/8a6ec41b-1b25-46f9-8d9d-cbe305f8b8a0)](https://codebeat.co/projects/github-com-ibm-swift-kitura-helloworld-ios-master-0d811d0a-4fc8-4cea-abfd-1af2b0b38d84)
&nbsp;[![Slack Status](http://swift-at-ibm-slack.mybluemix.net/badge.svg)](http://swift-at-ibm-slack.mybluemix.net/)

Simple Hello World Kitura Application (Server Side) embedded in an iOS app (Client Side).
The app demonstrates starting and stopping Kitura server, and presents Kitura log on the screen.

# Publications
* https://developer.ibm.com/swift/2017/03/13/kitura-ios/
* https://developer.ibm.com/swift/2017/12/08/kitura-ios-part2/

# Quick Instructions
(Last tested on macOS Mojave 10.14 and Xcode 10.1)

1. Setup (run in a terminal). The following commands install Xcode command line tools, Ruby Xcodeproj gem, download curl 7.43.0 source code and compile it. You may want to download and compile some other version of curl or to compile it using some other script, for example https://github.com/gcesarmza/curl-android-ios.
```
xcode-select --install
sudo gem install xcodeproj

git clone https://github.com/IBM-Swift/Kitura-HelloWorld-iOS.git
cd Kitura-HelloWorld-iOS
make Builder/Makefile

curl -O https://curl.haxx.se/download/curl-7.43.0.tar.bz2
bzip2 -d curl-7.43.0.tar.bz2; tar xopf curl-7.43.0.tar; rm -r curl-7.43.0.tar
bash ./Builder/Scripts/buildCurlStaticLibrary.sh curl-7.43.0
```

*Troubleshooting on Mojave*: if the last command above fails, follow the instructions in https://github.com/curl/curl/issues/3189#issuecomment-434889077.

2. The following command will fetch the submodules, update them, generate an Xcode project for the Server Side part and generate an Xcode workspace for the End-to-End project. 

For 64Bit (example, iPhone 5s or newer, iPad Air or newer, iPad Mini 2 or newer, iPad Pro or newer)
```
make openXcode
```

For 32Bit (example, iPhone 5, 5c, iPad 4)
```
make openXcode32
```

3. Open `EndToEnd.xcworkspace`
4. Change scheme to "ClientSide"
5. Load on iPhone or iPhone simulator
6. On the running app, turn on the toggle switch above the QR code
7. On another device, connect to the listed URL

# Quick Instructions for Updating the Project

1. `git pull` to get the latest version of Kitura
2. Remove the `Builder` directory
3. run `make openXcode` or `make openXcode32`

# Command Line Tests
Run `make test`
