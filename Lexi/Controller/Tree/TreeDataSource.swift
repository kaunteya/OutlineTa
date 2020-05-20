import Cocoa

extension TreeViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard element != nil else {
            return 0 // When no JSON content is not available
        }
        guard let item = item else {
            return 1 // Root element will always have one child
        }
        if let root = item as? NSArray {
            return root.count
        }
        return (item as! KNode).children!.count
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let tup = item as? KNode {
            return tup.isCollection
        }
        return item is NSArray
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item else {
            return element!
        }
        if let tup = item as? KNode {
            return tup.children![index]
        }
        return (item as! NSArray).object(at: index)
    }
}
