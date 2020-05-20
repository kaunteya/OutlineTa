import Cocoa

/// Subclass of NSButton that where type = .switch and .imageOnly
class CheckboxButton: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setButtonType(.switch)
        self.imagePosition = .imageOnly
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
