import Cocoa

class TextAreaCell: NSTableCellView, BasicTextCell {
    var shouldConsiderForSearchHighlighting: Bool = false

    weak var data: KNode!
    var type: KeyOrValue! {
        didSet {
            assert(data != nil, "Data must be set before setting type")
            textView.string = data.stringRepresentation(type: type, literalise: true, inQuotes: false)
        }
    }

    let textView: HuggingTextView

    var textColor: NSColor = NSColor.labelColor {
        didSet {
            textView.textColor = textColor
        }
    }

    init(containerSize: NSSize) {
        textView = HuggingTextView(containerSize: containerSize)
        super.init(frame: .zero)
        textView.textColor = textColor
        textView.backgroundColor = .clear
        textView.isFieldEditor = true
        textView.isRichText = false
        self.addSubview(textView)
        textView.applyConstraints { $0.top().left() }
        textView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        textView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        identifier = "TextAreaCell"
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFont(_ font: NSFont) {
        textView.font = font
    }

    func setEditability(_ isEditable: Bool) {
        textView.isEditable = isEditable
    }

    func setSelectability(_ isSelectable: Bool) {
        textView.isSelectable = isSelectable
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textView.prepareForReuse()
    }

    func highlightText(text: String, isCaseSensitive: Bool, isCurrent: Bool) {
        let nsstr = NSString(string: textView.string)
        let range = nsstr.range(of: text, options: .caseInsensitive)

        let backgroundColor = isCurrent ? AppColor.TreeView.Search.currentBackground : AppColor.TreeView.Search.background
        guard range.location != NSNotFound else {
            return
        }
        textView.layoutManager?.setTemporaryAttributes(
            [
                .foregroundColor: AppColor.TreeView.Search.text,
                .font: textView.font!,
                .backgroundColor: backgroundColor
            ],
            forCharacterRange: range
        )
    }
}
