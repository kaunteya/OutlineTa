import Cocoa

extension TreeViewController: JSONOutlineDelegate {
    func outlineViewSelectionDidChange(selectedKNode: KNode?) {
    }

    func outlineViewKeyColumnDidResize() {
    }

    func outlineView(_ outlineView: JSONOutlineView, viewFor tableColumn: JSONOutlineView.Column, kNode: KNode) -> BasicTextCell? {
        let type: KeyOrValue = (tableColumn == .key) ? .key : .value
        let cell = outlineView.makeView(type: type, for: kNode)
        return cell
    }

    func outlineView(_ outlineView: JSONOutlineView, heightOfRowFor kNode: KNode) -> CGFloat {
        if kNode.type == .string, (kNode.stringValue?.count ?? 0) > 15 {
            let cell = outlineView.makeView(type: .value, for: kNode) as! TextAreaCell
            cell.type = .value

            return cell.textView.contentSize.height
        }
        return CGFloat(defaults.fontSize) * 1.2
    }

    func outlineView(_ outlineView: JSONOutlineView, rowViewForKNode kNode: KNode) -> TreeRowView? {
        TreeRowView(outlineView: outlineView, kNode: kNode)
    }


    func outlineViewItemDidExpand(_ outlineView: JSONOutlineView, kNode: KNode) {
        // If expansion happened because of mouse then highlight childred
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            outlineView
                .rowView(of: kNode, makeIfNecessary: false)
                .map { $0.notifyExpansion() }
            outlineView.sizeLastColumnToFit()
        }
    }

    func outlineViewItemDidCollapse(_ outlineView: JSONOutlineView, kNode: KNode) {
    }

    func outlineViewValueColumnDidResize() {
        debouncedReload.renewInterval()
    }
}
