//
//  Crash Reporter.swift
//  Crash Reporter
//
//  Created by Daniel Witt on 20.11.19.
//  Copyright © 2019 Daniel Witt. All rights reserved.
//

import AppCenterCrashes
import AppKit

public class CrashReporterAC: NSObject, NSAlertDelegate {
    @IBOutlet var crashView: NSView!
    @IBOutlet var crashNameTextField: NSTextField!
    @IBOutlet var crashEmailAddressTextField: NSTextField!
    @IBOutlet var crashDescriptionTextFiew: CrashTextView!
    private var crashUserProvidedDescription: String?
    /// Useful for privacy statement
    var helpURL: URL?
    /// Uses the localized application application name by default
    var appName = NSRunningApplication.current.localizedName ?? ProcessInfo.processInfo.processName
    /// If `true` we changes to I and in the informative alert text
    var soloDeveloper = false
    
    public override init() {}
    
    public convenience init(helpURL: URL?) {
        self.init()
        self.helpURL = helpURL
        Bundle.main.loadNibNamed(NSNib.Name("Crash Reporter View"), owner: self, topLevelObjects: nil)
    }
    
    public var userConfirmationHandler: MSUserConfirmationHandler {
        return { (errorReports: [MSErrorReport]) in
            
            let defaults = UserDefaults.standard
            let crashAlert = self.crashAlert
            
            if errorReports.count == 1 {
                crashAlert.accessoryView = self.crashView
            }
            else {
                // TODO: Support multiple crashes. Might not be useful because the user does not know which crash happened when
                crashAlert.informativeText = self.soloDeveloper ? NSLocalizedString("Do you want to send me a crash report so I can fix the issue?", comment: "") : NSLocalizedString("Do you want to send us a crash report so we can fix the issue?", comment: "")
            }
            switch crashAlert.runModal() {
                case .alertFirstButtonReturn:
                    defaults.set(self.crashNameTextField.stringValue, forKey: "CrashUserName")
                    defaults.set(self.crashEmailAddressTextField.stringValue, forKey: "CrashEmailAddress")
                    self.crashUserProvidedDescription = "Name: \(self.crashNameTextField.stringValue)\n\nEmail Address: \(self.crashEmailAddressTextField.stringValue)\n\nDescription: \(self.crashDescriptionTextFiew.string)\n\n"
                    MSCrashes.notify(with: .send)
                case .alertSecondButtonReturn:
                    MSCrashes.notify(with: .dontSend)
                default:
                    break
            }
            
            return true
        }
    }
    
    private var crashAlert: NSAlert {
        let defaults = UserDefaults.standard
        self.crashNameTextField.stringValue = defaults.string(forKey: "CrashUserName") ?? NSFullUserName()
        self.crashEmailAddressTextField.stringValue = defaults.string(forKey: "CrashEmailAddress") ?? ""
        
        let crashAlert: NSAlert = NSAlert()
        crashAlert.messageText = String.localizedStringWithFormat(NSLocalizedString("Last time you used %@, it crashed. Sorry about that!", comment: ""), self.appName)
        crashAlert.informativeText = self.soloDeveloper ? NSLocalizedString("Do you want to send me a crash report so I can fix the issue? If you have the time, please let me know how and when the crash happened.", comment: "") : NSLocalizedString("Do you want to send us a crash report so we can fix the issue? If you have the time, please let us know how and when the crash happened.", comment: "")
        crashAlert.addButton(withTitle: NSLocalizedString("Send", comment: ""))
        crashAlert.addButton(withTitle: NSLocalizedString("Don't send", comment: ""))
        crashAlert.alertStyle = .warning
        crashAlert.showsHelp = self.helpURL != nil
        crashAlert.window.title = NSLocalizedString("Crash Reporter", comment: "")
        crashAlert.delegate = self
        
        return crashAlert
    }
    
    public func testCrashAlert() {
        let crashAlert = self.crashAlert
        crashAlert.accessoryView = self.crashView
        crashAlert.runModal()
    }
    
    public func alertShowHelp(_ alert: NSAlert) -> Bool {
        if let url = self.helpURL {
            if !NSWorkspace.shared.open(url) {
                NSLog("Unable to open URL \(url)")
            }
        }
        return true
    }
}

final class CrashTextView: NSTextView {
    private var placeholderAttributedString: NSAttributedString? {
        NSAttributedString(string: NSLocalizedString("Please provide any steps necessary to reproduce the issue.", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: NSColor.placeholderTextColor, NSAttributedString.Key.font: systemFont])
    }
    
    private var placeholderInsets = NSEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
    private var systemFont = NSFont.systemFont(ofSize: NSFont.systemFontSize)
    
    override func awakeFromNib() {
        font = self.systemFont
    }
    
    override func becomeFirstResponder() -> Bool {
        needsDisplay = true
        return super.becomeFirstResponder()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard string.isEmpty else { return }
        self.placeholderAttributedString?.draw(in: dirtyRect.insetBy(self.placeholderInsets))
    }
}

extension NSRect {
    func insetBy(_ insets: NSEdgeInsets) -> NSRect {
        return self.insetBy(dx: insets.left + insets.right, dy: insets.top + insets.bottom)
            .applying(CGAffineTransform(translationX: insets.left - insets.right, y: insets.top - insets.bottom))
    }
}
