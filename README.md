![Kitura Builder for iOS](https://raw.githubusercontent.com/IBM-Swift/Kitura-Builder-iOS/master/Documentation/KituraIOS.jpg)

# Kitura/iOS Hello World

![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![Apache 2](https://img.shields.io/badge/license-Apache2-blue.svg?style=flat)
&nbsp;[![Slack Status](http://swift-at-ibm-slack.mybluemix.net/badge.svg)](http://swift-at-ibm-slack.mybluemix.net/)

Simple Hello World Kitura Application (Server Side) embedded in an iOS app (Client Side).
The app demonstrates starting and stopping Kitura server, and presents Kitura log on the screen.

# Prerequisites
1. Enable Server-Side Swift with Kitura - see http://www.kitura.io/en/starter/settingup.html
2. Install Xcode Command Line Tools by running `xcode-select --install` command in the terminal
3. Create an iOS static library for `curl` package. Download curl zipped source from https://curl.haxx.se/download/, unzip it and run `UtilityScripts/buildCurlStaticLibrary.sh <path to the unzipped curl source directory>`. For example, if you unzip curl in the current directory, in `curl-7.43.0` directory, run `UtilityScripts/buildCurlStaticLibrary.sh curl-7.43.0`.

**We tested working with curl 7.43.0 version.**

# Build the project in Xcode
1. Type `make` in the terminal, an Xcode instance with a workspace will be opened. The workspace will contain both the client-side and the server-side parts as projects.
You should rerun `make` any time you change the structure of `ServerSide`  - add a file or add a dependency.
2. In the opened Xcode workspace, you can edit the code, both the client-side and server-side parts, debug and run the client-side iOS app (`ClientSide`) with the server side embedded in it.

You will see the URL of your Kitura/iOS server in the start screen of the app. Start the server by flipping the switch "STOPPED" on. Use another device (any OS) on the same Wi-Fi network. Point a browser in the other device to the displayed URL, you should get "Hello World!" message with a timestamp as a response. Alternatively, use the QR code displayed beside the URL of the server.

# Publications
See https://developer.ibm.com/swift/2017/03/13/kitura-ios/
