![Kitura Builder for iOS](https://raw.githubusercontent.com/IBM-Swift/Kitura-Builder-iOS/master/Documentation/KituraIOS.jpg)

# Kitura/iOS Hello World

![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![iOS](https://img.shields.io/badge/os-iOS-red.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)
[![codebeat badge](https://codebeat.co/badges/8a6ec41b-1b25-46f9-8d9d-cbe305f8b8a0)](https://codebeat.co/projects/github-com-ibm-swift-kitura-helloworld-ios-master-0d811d0a-4fc8-4cea-abfd-1af2b0b38d84)
&nbsp;[![Slack Status](http://swift-at-ibm-slack.mybluemix.net/badge.svg)](http://swift-at-ibm-slack.mybluemix.net/)

Simple Hello World Kitura Application (Server Side) embedded in an iOS app (Client Side).
The app demonstrates starting and stopping Kitura server, and presents Kitura log on the screen.

# Prerequisites
1. Enable Server-Side Swift with Kitura - see http://www.kitura.io/en/starter/settingup.html
2. Install Xcode Command Line Tools by running `xcode-select --install` command in the terminal
3. Run `make Builder/Makefile` - it will fetch the `Builder` submodule (and also the `ServerSide` submodule)
4. Create an iOS static library for `curl` package. Download curl zipped source from https://curl.haxx.se/download/, unzip it and run `Builder/Scripts/buildCurlStaticLibrary.sh <path to the unzipped curl source directory>`. For example, if you unzip curl in the current directory, in `curl-7.43.0` directory, run `Builder/Scripts/buildCurlStaticLibrary.sh curl-7.43.0`.

**We tested working with curl 7.43.0 version.**

# Build the project in Xcode
1. Type `make openXcode` in the terminal, an Xcode instance with a workspace will be opened. The workspace will contain both the client-side and the server-side parts as projects.
You should rerun `make openXcode` any time you change the structure of `ServerSide`  - add a file or add a dependency.
2. In the opened Xcode workspace, you can edit the code, both the client-side and server-side parts, debug and run the client-side iOS app (`ClientSide`) with the server side embedded in it.

You will see the URL of your Kitura/iOS server in the start screen of the app. Start the server by flipping the switch "STOPPED" on. Use another device (any OS) on the same Wi-Fi network. Point a browser in the other device to the displayed URL, you should get "Hello World!" message with a timestamp as a response. Alternatively, use the QR code displayed beside the URL of the server.

# Publications
See https://developer.ibm.com/swift/2017/03/13/kitura-ios/

# Quick Instructions
(macOS Sierra 10.12.4 and Xcode 8.3.2)

1. Setup (run in a terminal)
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

For 64Bit (example, iPhone 5s or newer, iPad Air or newer, iPad Mini 2 or newer, iPad Pro or newer)
```
make openXcode
```

For 32Bit (example, iPhone 5, 5c, iPad 4)
```
make openXcode32
```

2. Open `EndToEnd.xcworkspace`
3. Change scheme to "ClientSide"
4. Load on iPhone or iPhone simulator
5. On the running app, turn on the toggle switch above the QR code
6. On another device, connect to the listed URL

# Update -  Quick Instructions

1. `git pull` to get the latest version of Kitura
2. Remove the `Builder` directory
3. run `make openXcode` or `make openXcode32`
