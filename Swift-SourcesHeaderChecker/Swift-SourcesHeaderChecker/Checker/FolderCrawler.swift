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

/// Structure which has the aim of crawling in a folder to look for files ressources for further treatments.
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 01/07/2019
///
struct FolderCrawler {
    
    /// Goes recursively in the folder in parameter and keep only ressources matching the condition
    /// - Parameters:
    ///     - folder: The folder to process, path can be absolute or relative
    ///     - filtering: A regular expression to apply to the extension of the files (e.g. swift|sh)
    /// - Returns:
    ///     - An array of pathes to ressources matching the conditions
    ///
    func crawlIn(folder path: String, filtering byExtension: String) -> [String] {
        
        let filesEnumerator = FileManager.default.enumerator(atPath: path)
        let filesPaths = filesEnumerator?.allObjects as! [String]
        let ressourcesPaths = filesPaths.filter {
            let fileUrl = NSURL(fileURLWithPath: $0)
            guard let fileExtension = fileUrl.pathExtension else {
                return false
            }
            return fileExtension.range(of: byExtension, options: .regularExpression, range: nil, locale: nil) != nil
        }
        
        let consoleOutput = ConsoleOutput()
        consoleOutput.write("Founds \(ressourcesPaths.count) files with the extension '\(byExtension)'")
        
        var results: [String] = []
        for resourcePath in ressourcesPaths {
            let globalPath = "\(path)/\(resourcePath)" // FIXME: Seems dirty
            results.append(globalPath)
            consoleOutput.verbose("Found file located at '\(globalPath)'")
        }
        
        return results
        
    }
    
}
