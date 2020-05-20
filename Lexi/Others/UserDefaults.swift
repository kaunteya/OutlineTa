import Foundation
import Cocoa

let defaults = UserDefaults.standard

extension UserDefaults {
    static func registerDefaults() {
        standard.register(
            defaults:
            [
                "splitViewIsVertical": true,
                "fontSize": Int(NSFont.systemFontSize),
                "indentationSpace": 4,
                "showLineNumbers": true,
                "syntaxHighlighting": true,
                "maxCharsSyntaxHighlighting": 1_00_000
            ]
        )
    }

    @objc dynamic var splitViewIsVertical: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function)}
    }

    @objc dynamic var fontSize: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function)}
    }

    @objc dynamic var firstLaunchDate: Date? {
        get { value(forKey: #function) as? Date}
        set { set(newValue, forKey: #function)}
    }
    @objc dynamic var indentationSpace: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function)}
    }
    @objc dynamic var showLineNumbers: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function)}
    }
    @objc dynamic var syntaxHighlighting: Bool {
        get { return bool(forKey: #function) }
        set { set(newValue, forKey: #function)}
    }
    @objc dynamic var maxCharsSyntaxHighlighting: Int {
        get { return integer(forKey: #function) }
        set { set(newValue, forKey: #function)}
    }

    @objc dynamic var versionList: [String] {
        get { return stringArray(forKey: #function) ?? [] }
        set { set(newValue, forKey: #function)}
    }
}
