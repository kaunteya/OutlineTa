import Cocoa

extension NSTableView {
    /// Scrolls table view such that the selected row is brought to center
    func scrollRowCenteredToVisible(row: Int, animated: Bool) {
        let rowRect = self.frameOfCell(atColumn: 0, row: row)
        if let scrollView = self.enclosingScrollView {
            let centeredPoint = NSPoint(x: 0, y: rowRect.origin.y + (rowRect.size.height / 2) - ((scrollView.frame.size.height) / 2))
            if animated {
                scrollView.contentView.animator().setBoundsOrigin(centeredPoint)
            } else {
                self.scroll(centeredPoint)
            }
        }
    }

    func isRowVisible(_ row: Int) -> Bool {
        rows(in: visibleRect).contains(row)
    }
}
