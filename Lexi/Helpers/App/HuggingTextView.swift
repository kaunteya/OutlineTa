import Cocoa

class HuggingTextView: NSTextView, NSTextViewDelegate {
    var selectionChanged: ((NSTextView) -> Void)?

    /// Triggered when there is any mouse activity in textview
    /// This istriggered from becomesFirstResponder
    var onStartedResponding: (() -> Void)?
    var onTextChange: ((String) -> Void)?

    convenience init(containerSize: CGSize) {
        let container = NSTextContainer(containerSize: containerSize)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(container)
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)

        self.init(frame: .zero, textContainer: container)
        wantsLayer = true
        delegate = self
        layer?.cornerRadius = 2

        let trackingArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect], owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }

    override var textColor: NSColor? {
        didSet {
            guard let color = textColor, layer != nil else { return }
            layer!.borderColor = color.withAlphaComponent(0.6).cgColor
        }
    }

    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
    }

    override init(frame frameRect: NSRect) {
        fatalError("initialize only from init(containerSize: CGSize)")
    }

    required init?(coder: NSCoder) {
        fatalError("initialize only from init(containerSize: CGSize)")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        layer?.borderWidth = 0
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    override func mouseEntered(with event: NSEvent) {
        guard isEditable else { return }
        layer?.backgroundColor = textColor?.withAlphaComponent(0.1).cgColor
        layer?.borderWidth = 1
    }

    override func mouseExited(with event: NSEvent) {
        guard isEditable else { return }
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.borderWidth = 0
    }

    override var intrinsicContentSize: NSSize {
        guard let container = textContainer, let manager = container.layoutManager else {
            return super.intrinsicContentSize
        }
        manager.ensureLayout(for: container)
        let gr = manager.usedRect(for: container).size
        return gr
    }

    override func becomeFirstResponder() -> Bool {
        onStartedResponding?()
        return super.becomeFirstResponder()
    }

    func textDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
        onTextChange?(string)
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        if selectedRange().length > 0 {
            selectionChanged?(self)
        }
    }
}
