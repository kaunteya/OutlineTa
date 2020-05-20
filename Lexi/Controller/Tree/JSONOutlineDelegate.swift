import Cocoa

protocol JSONOutlineDelegate: AnyObject {
    func outlineView(_ outlineView: JSONOutlineView, viewFor tableColumn: JSONOutlineView.Column, kNode: KNode) -> BasicTextCell?
    func outlineView(_ outlineView: JSONOutlineView, rowViewForKNode kNode: KNode) -> TreeRowView?
    func outlineViewSelectionDidChange(selectedKNode: KNode?)
    func outlineViewItemDidExpand(_ outlineView: JSONOutlineView, kNode: KNode)
    func outlineViewItemDidCollapse(_ outlineView: JSONOutlineView, kNode: KNode)
    func outlineView(_ outlineView: JSONOutlineView, heightOfRowFor kNode: KNode) -> CGFloat
    func outlineViewKeyColumnDidResize()
    func outlineViewValueColumnDidResize()
}
