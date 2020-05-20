import Cocoa

class TreeRowView: NSTableRowView {
    weak var outlineView: JSONOutlineView!
    weak var kNode: KNode!

    var disclosureButton: NSButton? {
        return subviews.first { $0 is NSButton } as? NSButton
    }

    convenience init(outlineView: JSONOutlineView, kNode: KNode) {
        self.init()
        self.outlineView = outlineView
        self.kNode = kNode
    }

    func notifyExpansion() {
    }

    func notifyCollapse() {
    }

    override func drawSelection(in dirtyRect: NSRect) {
        let markerWidth: CGFloat = 2
        let markerPath = NSBezierPath(rect: NSRect(x: 0, y: 0, width: markerWidth, height: bounds.height))
        NSColor.controlAccentColor.withAlphaComponent(0.5).setFill()
        markerPath.fill()

        let highlightPath = NSBezierPath(rect: NSRect(x: markerWidth, y: 0, width: bounds.width, height: bounds.height))
        NSColor.lightGray.withAlphaComponent(0.05).setFill()
        highlightPath.fill()
    }
}
