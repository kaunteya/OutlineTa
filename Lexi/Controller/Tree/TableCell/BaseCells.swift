import Cocoa

protocol BasicTextCell where Self: NSTableCellView {
    var data: KNode! { get set }
    var type: KeyOrValue! { get set }
    var textColor: NSColor { get set }
    var shouldConsiderForSearchHighlighting: Bool { get set }
    func highlightText(text: String, isCaseSensitive: Bool, isCurrent: Bool)
    func setFont(_ font: NSFont)
    func setEditability(_ isEditable: Bool)
    func setSelectability(_ isSelectable: Bool)
}
