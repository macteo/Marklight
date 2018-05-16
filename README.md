# Marklight

Markdown syntax highlighter for iOS and macOS.

[![License MIT](https://img.shields.io/cocoapods/l/Marklight.svg)](https://raw.githubusercontent.com/macteo/marklight/master/LICENSE) [![Version](https://img.shields.io/cocoapods/v/Marklight.svg)](https://cocoapods.org/?q=marklight) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![travis-ci](https://travis-ci.org/macteo/Marklight.svg?branch=master)](https://travis-ci.org/macteo/Marklight)
[![codecov.io](https://codecov.io/github/macteo/Marklight/coverage.svg?branch=feature/swift4)](https://codecov.io/github/macteo/Marklight?branch=master)
![Swift 4.1](https://img.shields.io/badge/language-Swift%204.1-EB7943.svg) ![iOS 8+](https://img.shields.io/badge/iOS-8+-EB7943.svg)

## Description

Marklight is a drop in component to easily add realtime Markdown syntax highlight on any user editable text view in iOS and macOS applications.
Marklight doesn't include HTML generation from Markdown, but you can use one of the many other components available like [Markingbird](https://github.com/kristopherjohnson/Markingbird).

Regular expressions are taken from [Markingbird](https://github.com/kristopherjohnson/Markingbird), a Markdown parser and html generator.

![Marklight Gif](https://raw.githubusercontent.com/macteo/Marklight/master/Assets/marklight.gif)![Screenshot 0](https://raw.githubusercontent.com/macteo/Marklight/master/Assets/screenshot-0.png)

## Features

- [x] Applicable to any `UITextView`.
- [x] `NSTextStorage` subclass ready to use.
- [x] Struct optimized for performances.
- [x] Swift 4.1 compatible.
- [x] Dynamic text style supported.
- [x] Choose markdown syntax color.
- [x] Choose font and color for code blocks.
- [x] Choose font and color for quotes.
- [x] Choose dynamic type font text style.
- [x] Quote indentation.
- [x] Documented.
- [x] macOS compatibility.
- [ ] Parsing tests.
- [ ] Performance tests.

## Requirements

- iOS 8.0+
- Xcode 9.3+
- macOS 10.11+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.0.0+ is required to build Marklight.

To integrate Marklight into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Marklight'
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install [Carthage](https://github.com/Carthage/Carthage) with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Marklight into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "macteo/Marklight"
```

Run `carthage update --platform iOS` to build the framework and drag the built `Marklight.framework` into your Xcode project.

### Manually

Add the *Marklight* Xcode project to your own. Then add the `Marklight` framework as desired to the embedded binaries of your app's target.

## Usage

In this repository you can find a sample project with few lines of code in the `ViewController` class for a jumpstart.

*Sample code is written in Swift but Objective-C should be supported too, if you find an incompatibility please open an issue.*

### Integration

The easiest way to crete a user editable `UITextView` with markdown syntax highlight is to use the provided `MarklightTextStorage` class as `NSTextStorage` and add the `UITextView`'s `textLayout` to the `MarklightTextStorage` text storage.

Import *Marklight* modules into your Swift class

```swift
import Marklight
```

or if you are writing in Objective-C

```objc
#import <Marklight/Marklight-Swift.h>
```

> Keep in mind the you have to let the project generate the Bridging Header otherwise the integration may fail.

In your `UIViewController` subclass keep a strong instance of the this `MarklightTextStorage` class.

```swift
let textStorage = MarklightTextStorage()
```

Customize the appearance as desired:

* Dynamic text style.
* Markdown syntax color.
* Code's font and color.
* Quotes' font and color.

As per Apple's documentation it should be enough to assign the `UITextView`'s `NSLayoutManager` to the `NSTextStorage` subclass, in our case `MarklightTextStorage`.

```swift
 textStorage.addLayoutManager(textView.layoutManager)
```
However I'm experiencing some crashes if I want to preload some text instead of letting the user start from scratch with a new text. A workaround is proposed below.

For simplicity we assume you have a `String` to be highlighted inside an editable `UITextView` loaded from a storyboard.

```swift
let string = "# My awesome markdown string"
```

Convert `string` to an `NSAttributedString`

```swift
let attributedString = NSAttributedString(string: string)
```

Set the loaded string to the `UITextView`

```swift
textView.attributedText = attributedString
```

Append the loaded string to the `NSTextStorage`

```swift
textStorage.appendAttributedString(attributedString)
```

Enjoy.

## Acknowledgements

* Matteo Gavagnin – [@macteo](https://twitter.com/macteo)
* Christian Tietze (macOS Port) - [@ctietze](https://twitter.com/ctietze), [GitHub](http://github.com/DivineDominion)

---

Marklight is heavily based on [Markingbird](https://github.com/kristopherjohnson/Markingbird), so many thanks to [Kristopher Johnson](http://undefinedvalue.com) and every previous contribution on which [Markingbird](https://github.com/kristopherjohnson/Markingbird) is based upon.

## License

Marklight is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/macteo/Marklight/master/LICENSE) for details.
