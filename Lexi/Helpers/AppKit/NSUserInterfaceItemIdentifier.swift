import Cocoa

extension NSUserInterfaceItemIdentifier: ExpressibleByStringLiteral {
    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}
