import Cocoa

class JSONOutlineView: NSOutlineView {
    enum Column: String {
        case key, value
        init(_ type: KeyOrValue) {
            if type == .key {
                self = .key
            } else {
                self = .value
            }
        }
    }

    /// The textview that has text selected
    weak var textSelectionTextView: NSTextView? {
        willSet {
            guard textSelectionTextView != nil,
                textSelectionTextView != newValue else { return }
            textSelectionTextView?.clearSelection()
        }
    }

    weak var jDelegate: JSONOutlineDelegate!

    override init(frame frameRect: NSRect) {
        fatalError()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemRed
        setColumnTextAttributes(textColor: AppColor.TreeView.columnTextColor, font: .systemFont(ofSize: 12))
        delegate = self
    }

    private func allVisibleChildren(of kNode: KNode) -> [TreeRowView] {
        return visibleRows
            .map { $0 as! TreeRowView }
            .filter { self.is(item: $0.kNode!, childOf: kNode) }
    }

    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        let view = super.makeView(withIdentifier: identifier, owner: owner)

        if view?.identifier?.rawValue == "NSOutlineViewDisclosureButtonKey" {
            // Disable template mode of diclosure button as it became white
            // on selection and wasnt visible in light mode
            let b = view as! NSButton
            b.image?.isTemplate = false
            b.alternateImage?.isTemplate = false
            b.action = #selector(buttonPressed(_:))
        }
        return view
    }

    @objc func buttonPressed(_ sender: NSButton) {
        let selector = Selector(("_outlineControlClicked:"))
        self.perform(selector, with: sender)
        if let rowView = sender.superview as? TreeRowView {
            self.select(rowView.kNode)
        }
    }

    private func textColor(kNode: KNode, for type: KeyOrValue) -> NSColor {
        switch (type, kNode.type) {
        case (.key, _): return AppColor.JSON.key
        case (.value, .null): return AppColor.JSON.null
        case (.value, .bool): return AppColor.JSON.bool
        case (.value, .num): return AppColor.JSON.number
        case (.value, .string): return AppColor.JSON.string
        case (.value, .array), (.value, .dict): return AppColor.JSON.valueCollectionCount
        }
    }

    private func isEditable(_ kNode: KNode, for type: KeyOrValue) -> Bool {
        switch (type, kNode.type) {
        case (.key, _) where kNode.parent?.type == .dict,
        (.value, .bool), (.value, .num), (.value, .string):
            return true
        default: return false
        }
    }

    private func isSearchHighlightable(_ kNode: KNode, for type: KeyOrValue) -> Bool {
        switch (type, kNode.type) {
        case (.value, .array), (.value, .dict): return false
        default: return true
        }
    }

    func makeView(type: KeyOrValue, for kNode: KNode) -> BasicTextCell {
        let cell: BasicTextCell
        if type == .value, kNode.type == .bool {
            cell = BoolCell()
        } else {
            let width = column(Column(type)).width
            let textCell: TextAreaCell
            let size = NSSize(width: width, height: CGFloat.greatestFiniteMagnitude)
            if let c = makeView(withIdentifier: "TextAreaCell", owner: self) as? TextAreaCell {
                textCell = c
                textCell.textView.textContainer?.containerSize = size
            } else {
                textCell = TextAreaCell(containerSize: size)
            }

            textCell.textView.selectionChanged = {
                return { [weak self] (textView: NSTextView) in
                    self?.textSelectionTextView = textView
                }
            }()
            textCell.textView.onStartedResponding = {
                return { [weak self] in
                    self?.select(kNode)
                }
            }()
            textCell.textView.onTextChange = {
                return { newStr in
                    switch (type, kNode.type) {
                    case (.key, _):
                        kNode.key = newStr
                    case (.value, .string), (.value, .num):
                        kNode.stringValue = newStr
                    default: break
                    }
                }
                }()
            cell = textCell
        }

        cell.setFont(.systemFont(ofSize: CGFloat(defaults.fontSize)))
        cell.data = kNode
        cell.type = type
        cell.setEditability(isEditable(kNode, for: type))
        cell.setSelectability(isEditable(kNode, for: type))
        cell.textColor = textColor(kNode: kNode, for: type)
        cell.shouldConsiderForSearchHighlighting = isSearchHighlightable(kNode, for: type)
        return cell
    }
}

// MARK: - kNode specific helpers
extension JSONOutlineView {
    var selectedNode: KNode? {
        return kNode(at: selectedRow)
    }

    var firstElement: KNode? {
        return kNode(at: 0)
    }

    func kNode(at row: Int) -> KNode? {
        return item(atRow: row) as? KNode
    }

    func kNode(at point: CGPoint) -> KNode? {
        return kNode(at: row(at: point))
    }

    func parent(of kNode: KNode?) -> KNode? {
        return super.parent(forItem: kNode) as? KNode
    }

    func child(_ index: Int, of item: KNode?) -> KNode? {
        return child(index, ofItem: item) as? KNode
    }

    func kNode(forCell view: NSView) -> KNode? {
        return item(atRow: row(for: view)) as? KNode
    }

    func rowView(of kNode: KNode?, makeIfNecessary: Bool) -> TreeRowView? {
        let rowViewIndex = row(forItem: kNode)
        guard rowViewIndex > 0 else { return nil }
        return rowView(atRow: rowViewIndex, makeIfNecessary: makeIfNecessary) as? TreeRowView
    }

    func select(_ kNode: KNode?) {
        let index = row(forItem: kNode)
        selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
    }

    func jumpToRow(at node: KNode?, animated: Bool) {
        guard let node = node else { return }
        node.pathFromRoot.dropLast().forEach(expandItem)

        let r = row(forItem: node)
        selectRowIndexes(IndexSet(integer: r), byExtendingSelection: false)
        if isRowVisible(r) == false {
            self.scrollRowCenteredToVisible(row: r, animated: animated)
        }
    }

    func column(_ col: Column) -> NSTableColumn {
        return tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: col.rawValue))!
    }

    func expandAll() {
        expandItem(firstElement, expandChildren: true)
    }

    func collapseAll() {
        collapseItem(firstElement, collapseChildren: true)
    }
}


extension JSONOutlineView: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let col = Column(rawValue: tableColumn!.identifier.rawValue)!
        return jDelegate.outlineView(
            outlineView as! JSONOutlineView,
            viewFor: col,
            kNode: item as! KNode
        )
    }

    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        return jDelegate.outlineView(outlineView as! JSONOutlineView, rowViewForKNode: item as! KNode)
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        jDelegate.outlineViewSelectionDidChange(selectedKNode: selectedNode)
    }

    func outlineViewItemDidExpand(_ notification: Notification) {
        let kNode = notification.userInfo!["NSObject"] as! KNode
        let outlineView = notification.object as! JSONOutlineView
        jDelegate.outlineViewItemDidExpand(outlineView, kNode: kNode)
    }

    func outlineViewItemDidCollapse(_ notification: Notification) {
        let kNode = notification.userInfo!["NSObject"] as! KNode
        let outlineView = notification.object as! JSONOutlineView
        jDelegate.outlineViewItemDidCollapse(outlineView, kNode: kNode)
    }

    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        jDelegate.outlineView(outlineView as! JSONOutlineView, heightOfRowFor: item as! KNode)
    }

    func outlineViewColumnDidResize(_ notification: Notification) {
        let col = notification.userInfo!["NSTableColumn"] as! NSTableColumn
        switch Column(rawValue: col.identifier.rawValue)! {
        case .key: jDelegate.outlineViewKeyColumnDidResize()
        case .value: jDelegate.outlineViewValueColumnDidResize()
        }
    }
}
