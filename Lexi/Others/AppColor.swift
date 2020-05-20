import Cocoa

public extension NSColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(calibratedRed: red, green: green, blue: blue, alpha: alpha)
    }
}

enum AppColor {
    enum JSON {
        static var key: NSColor {
            isDark ? NSColor(hex: 0x9baaba) : NSColor(hex: 0x2b2a2a)
        }
        static var null: NSColor {
            isDark ? NSColor(hex: 0x41A1C0) : NSColor(hex: 0x0F68A0)
        }
        static var bool: NSColor {
            isDark ? NSColor(hex: 0xFC8F3E) : NSColor(hex: 0x63381F)
        }
        static var number: NSColor {
            isDark ? NSColor(hex: 0xFB6A5D) : NSColor(hex: 0xC41A15)
        }
        static var string: NSColor {
            isDark ? NSColor(hex: 0x91D361) : NSColor(hex: 0x316C74)
        }
        static var valueCollectionCount = NSColor.secondaryLabelColor
    }

    enum TreeView {
        static var background: NSColor { .controlBackgroundColor }
        static var columnTextColor: NSColor { .secondaryLabelColor }

        enum Search {
            static var text: NSColor = .selectedTextColor
            static var background: NSColor = .secondaryLabelColor
            static var currentBackground: NSColor = .selectedTextBackgroundColor
        }
    }

    enum TextView {
        static var background: NSColor { .controlBackgroundColor }
        static var text: NSColor { isDark ? NSColor(hex: 0x9baaba) : NSColor(hex: 0x2b2a2a) }
        static var lineNumber: NSColor { isDark ? NSColor(hex: 0x747478).withAlphaComponent(0.5) : NSColor(hex: 0xa6a6a6) }
    }
}
