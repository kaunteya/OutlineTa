import Cocoa

class HuggingTextField: NSTextField, NSTextFieldDelegate {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        make()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        make()
    }

    func make() {
        self.wantsLayer = true
        self.isBordered = false
        self.delegate = self
        self.focusRingType = .none
        //        self.font = NSFont.systemFont(ofSize: 13)
        self.maximumNumberOfLines = 1
        self.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
        self.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .vertical)
        self.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 1000), for: .horizontal)
    }

    override var intrinsicContentSize: NSSize {
        let size = (stringValue + "  ").size(withAttributes: [.font: font!])
        return NSSize(width: size.width, height: size.height)
    }

//    override func resetCursorRects() {
//        addCursorRect(bounds, cursor: .iBeam)
//    }

    func controlTextDidChange(_ obj: Notification) {
        invalidateIntrinsicContentSize()
    }
}
