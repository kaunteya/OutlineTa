import Cocoa
import Combine

class TreeViewController: NSViewController {
    @IBOutlet var outlineView: JSONOutlineView!
    @IBOutlet var progressIndicator: NSProgressIndicator!

var json = """
{
    "isAlive": true,
    "lucky_numbers": [
        23454332,
        54.12
    ],
    "name": {
        "first": "Steve",
        "last": "Jobs",
        "profile": "https://google.com"
    },
    "value": null,
    "percent": 84.34,
    "text-color": "#e84118",
    "phone": [
        "+91 94920423",
        "2354343423"
    ],
    "emo": "📖"
}
"""

    var element: KNode? {
        didSet {
            outlineView.reloadData()
            // Expand first item by default
            outlineView.expandItem(outlineView.firstElement)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        outlineView.jDelegate = self
        self.element = try! KNode(string: json)

    }

    lazy var debouncedReload = Debouncer(timeInterval: 0.2) { [weak self] in
           let n = self?.outlineView.selectedNode
           self?.outlineView.reloadData()
           self?.outlineView.select(n)
       }
}
