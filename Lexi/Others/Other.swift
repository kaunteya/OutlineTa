import Foundation
import Cocoa

extension NSError {
    var errorString: String {
        userInfo["NSDebugDescription"] as? String ?? localizedDescription
    }
}

extension Range {
    var isNotEmpty: Bool { !isEmpty }
}

extension String {
    /// Converts a location in string to line number
    func lineNumber(for location: Int) -> Int {
        var lineCount = 0
        for (i, c) in enumerated() where i < location && c.isNewline {
            lineCount += 1
        }
        return lineCount
    }
}
