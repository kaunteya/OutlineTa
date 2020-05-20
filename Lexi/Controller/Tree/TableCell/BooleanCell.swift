import Cocoa

class BoolCell: NSTableCellView, BasicTextCell {
    let button = CheckboxButton()

    weak var data: KNode!
    var type: KeyOrValue! {
        didSet {
            assert(data != nil, "Data must be set before setting type")
            textField!.stringValue = data.valueString(literalise: true, inQuotes: false)
            needsLayout = true
            button.state = data.boolValue ? .on : .off
        }
    }

    var textColor: NSColor = .labelColor {
        didSet {
            textField!.textColor = textColor
        }
    }

    var shouldConsiderForSearchHighlighting: Bool = true

    let huggingTextField: HuggingTextField = {
        let h = HuggingTextField()
        h.isBordered = false
        h.backgroundColor = .clear
        return h
    }()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.textField = huggingTextField
        let stack = HStack(views: [button, textField!])
            .alignment(.centerY)
            .spacing(2)
        addSubview(stack) { $0.left(6).top() }
        identifier = "BoolCell"
        button.target = self
        button.action = #selector(buttonPressed(_:))
    }

    func setFont(_ font: NSFont) {
        textField!.font = font
    }

    func setEditability(_ isEditable: Bool) {
        textField!.isEditable = isEditable
    }

    func setSelectability(_ isSelectable: Bool) {
        textField!.isSelectable = isSelectable
    }

    @objc func buttonPressed(_ sender: CheckboxButton) {
        data.boolValue = sender.state == .on
        textField!.stringValue = data.valueString(literalise: false, inQuotes: false)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highlightText(text: String, isCaseSensitive: Bool, isCurrent: Bool) {
    }
}
