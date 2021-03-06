# CrashReporterAC

[![Version](https://img.shields.io/cocoapods/v/CrashReporterAC.svg?style=flat)](https://cocoapods.org/pods/CrashReporterAC)
[![License](https://img.shields.io/cocoapods/l/CrashReporterAC.svg?style=flat)](https://cocoapods.org/pods/CrashReporterAC)
[![Platform](https://img.shields.io/cocoapods/p/CrashReporterAC.svg?style=flat)](https://cocoapods.org/pods/CrashReporterAC)

## Description
A bug report contains device logs, stack traces, and other diagnostic information to help you find and fix bugs in your app. It should also include user feedback that helps you to reproduce the issue. Unfortunately that's not part of [Microsoft' AppCenter](https://appcenter.ms/apps)  implementation for macOS. However there are APIs that allow you to send text attachments with each crash. CrashReporterAC asks the user for feedback and submits it with the crash details to AppCenter.

## Screenshot

![](Screenshot.png)
![](Screenshot2.png)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- macOS 10.10
- [Microsoft AppCenter](https://appcenter.ms/apps) 

## Installation

CrashReporterAC is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CrashReporterAC'
```

Add this to your AppDelegate:
```
private let crashReporterAC = CrashReporterAC(helpURL: URL(string: "https://example.com/privacy/#app-center"))
```

Make sure to add the following **before** calling `AppCenter.start()`, usually in `applicationDidFinishLaunching(_:)`:


```swift
Crashes.delegate = self //Call this before AppCenter.start(...)
let crashReporterAC = CrashReporterAC(helpURL: URL(string: "https://example.com/privacy/#app-center"))
Crashes.userConfirmationHandler = crashReporterAC.userConfirmationHandler
```

Also implement the delegates:


```swift
// MARK: - CrashesDelegate
    
func attachments(with crashes: Crashes, for errorReport: ErrorReport) -> [ErrorAttachmentLog] {
    guard crashReporterAC.crashUserProvidedDescription != nil else {
        return []
    }

    let attachment1 = ErrorAttachmentLog.attachment(withText: crashReporterAC.crashUserProvidedDescription!, filename: "UserProvidedDescription.txt")
    return [attachment1! 
}
    
func crashes(_ crashes: Crashes, didFailSending errorReport: ErrorReport, withError error: Error) {
    crashReporterAC.crashUserProvidedDescription = nil
}
    
func crashes(_ crashes: Crashes, didSucceedSending errorReport: ErrorReport) {
    crashReporterAC.crashUserProvidedDescription = nil
}
```

## Author

Daniel Witt, info@witt-software.com

## Localization

* Massimiliano Picchi (Italian)
* Ange Lefrère (French)
* Daniel Witt (German)

## License

CrashReporterAC is available under the MIT license. See the LICENSE file for more info.
