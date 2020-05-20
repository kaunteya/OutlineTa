import Foundation

extension String {
    /// Literalizes escape sequences. Adds one more backslash so the string
    /// escaping remains
    ///
    /// "\0" -> "\\\0"
    ///
    /// "\\\\" -> "\\\\\\"
    var literalized: String {
        let escapeSequences = [("\0", "\\0"), ("\\", "\\\\"), ("\t", "\\t"), ("\n", "\\n"), ("\r", "\\r"), ("\"", "\\\"")]
        return escapeSequences.reduce(self) { string, seq in
            string.replacingOccurrences(of: seq.0, with: seq.1)
        }
    }
}
