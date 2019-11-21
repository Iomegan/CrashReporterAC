//
//  AppDelegate.swift
//  Crash Reporter
//
//  Created by Daniel Witt on 20.11.19.
//  Copyright © 2019 Daniel Witt. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBAction func showCrashReporterDialog(_ sender: Any) {
        let crashReporter = CrashReporter(helpURL: URL(string: "https://www.apple.com"))
        crashReporter.testCrashAlert()
    }
}
