import Cocoa

extension NSOutlineView {
    func `is`<T: AnyObject>(item: T, childOf parent: T) -> Bool {
        var item: T? = item
        while item != nil {
            if item === parent {
                return true
            }
            item = self.parent(forItem: item) as? T
        }
        return false
    }

    var visibleRows: [NSTableRowView] {
        var rows = [NSTableRowView]()
        enumerateAvailableRowViews { (view, _) in
            rows.append(view)
        }
        return rows
    }

    func setColumnTextAttributes(textColor: NSColor? = nil, font: NSFont? = nil) {
        var dict = [NSAttributedString.Key: Any]()
        if let c = textColor {
            dict[.foregroundColor] = c
        }
        if let f = font {
            dict[.font] = f
        }

        tableColumns.forEach { col in
            col.headerCell.attributedStringValue = NSAttributedString(string: col.title, attributes: dict)
        }
    }
}
