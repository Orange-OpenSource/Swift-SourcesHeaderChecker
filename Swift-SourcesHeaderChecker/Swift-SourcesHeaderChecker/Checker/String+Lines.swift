/**
     Swift-SourcesHeaderChecker
     Copyright (C) 2019 Orange SA
 
     MIT License
 
     Permission is hereby granted, free of charge, to any person obtaining a copy
     of this software and associated documentation files (the "Software"), to deal
     in the Software without restriction, including without limitation the rights
     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
     copies of the Software, and to permit persons to whom the Software is
     furnished to do so, subject to the following conditions:
     The above copyright notice and this permission notice shall be included in all
     copies or substantial portions of the Software.
     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
     SOFTWARE.
 */

import Foundation

/// Extension of the String legacy obejcts adding to it useful methods for lines processing
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.1.0
/// - Since: 01/07/2019
///
extension String {
 
    /// The array of lines of the string, using the newlines characters to split it
    var lines: [String] {
        return self.components(separatedBy: NSCharacterSet.newlines)
    }

    /// The number of lines in this string
    var linesCount: Int {
        var count = 0
        self.enumerateLines { (_, _) in
            count += 1
        }
        return count
    }
    
    /// Returns the first k lines of the string in an Array
    /// - Parameters:
    ///     - k: The maximum number of lines to return
    /// - Returns:
    ///     - The array of lines
    ///
    func linesUntil(k limit: Int) -> [String] {
        return Array(lines.prefix(limit))
    }
 
    /// Removes special characters in the string so as to make it cleaner.
    /// Not sure this function is optimized.
    /// - Parameters:
    ///     - chars: The values to remove
    /// - Returns:
    ///     - The updated value of the current string
    ///
    func clear(of values: String = " \n\t\r//") -> String {
        return self.filter { !values.contains($0) }
    }
    
    /// Checks if the String can be considered as a comment line, i.e. starts
    /// with special symbols like '/**', '/*' or '//'
    /// - Returns:
    ///     - True if starts with such symbols, false otherwise
    ///
    func isCommentLine() -> Bool {
        return self.starts(with: "/**")
        || self.starts(with: "/*")
        || self.starts(with: "//")
    }
    
}
