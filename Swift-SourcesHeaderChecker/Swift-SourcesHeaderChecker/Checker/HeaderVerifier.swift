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

/// Structure which has the aim of reading files and check if they contain in the top the suitable
/// leagal mentions in the header.
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 2.0.0
/// - Since: 01/07/2019
///
struct HeaderVerifier {
    
    // Mark: - Variables
    
    /// To display messages in the console
    let output = ConsoleOutput()
    
    // Mark: - Functions
    
    /// Reads the content of the all the files at these paths and look for the mention.
    /// - Parameters:
    ///     - at: The array of files' paths which must contain the header
    ///     - for: The content of the header to get in the top of the files
    ///     - ignoring: The number of lines to ignore starting from the top of the processed file
    /// - Returns:
    ///     - A boolean value indicating if the header is available in all the files (true)
    /// or not (false if at least 1 file)
    ///
    func look(at files: [String], for mention: String, ignoring lines: Int) -> Bool {
        output.verbose("Will process \(files.count) files")
        var allFilesAreSuitable = true
        for file in files {
            output.verbose("Processing file '\(file)")
            let isFileSuitable = look(at: file, for: mention, ignoring: lines)
            if !isFileSuitable {
                output.write("❌ It seems the file at \(file) does not have a suitable header")
            }
            allFilesAreSuitable = allFilesAreSuitable && isFileSuitable
        }
        return allFilesAreSuitable
    }
    
    /// Reads the content of the file at this path and look for the mention in its head.
    /// Considers the in-use file is written in Swift.
    /// The formalism is not important, will deal mainly with the textual content rather than
    /// some special characters (tab or 4 spaces, carriage return, etc). However even if special characters
    /// are not considered within a line, the empty lines matter. So if the file as more empty lines
    /// than expected, it will be rejected.
    ///
    /// Will consider as suitable a file which has its header matching the following conditions:
    /// 1 - no hashbang in first line (because of 3)
    /// 2 - no import in first line (because of 3)
    /// 3 - starts with /** or /* or //
    /// 4 - has */ ending the header or //
    ///
    /// - Parameters:
    ///     - at: The path to the source file which should contain the expected header
    ///     - for: The header content to find
    ///     - ignoring: The number of lines to ignore starting from the top of the processed file
    /// - Returns:
    ///     - A boolean value indicating if the header is available (true) or not (false)
    ///
    func look(at path: String, for mention: String, ignoring lines: Int) -> Bool {
        
        // Read the current file
        guard let currentFileContent = try?
            String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8) else {
            output.write("⚠️  It seems this Swift file (\(path)) cannot be read. Will reject it.")
            return false
        }

        // Check if the line starts by /**, /* or //
        if !currentFileContent.isCommentLine() {
            output.write("⚠️  It seems the Swift file at (\(path)) does not start with '/**' or '/*' or '//'. Will reject it.")
            return false
        }
        
        // Compare line by line
        // FIXME Can we optimize this part with low-cost methods or standard API?
        let cutFileContent: String = currentFileContent.linesSince(k: lines)
        let splittedFileContent: [String] = cutFileContent.linesUntil(k: mention.linesCount + 2) // Keep ending line
        let splittedMention = mention.lines
        for i in 0..<mention.linesCount {
            // TODO Deal with case where the name of the file is in the header -_-
            let cleanedMentionLine = splittedMention[i].clear()
            let cleanedFileContentLine = splittedFileContent[i+1].clear()
            if cleanedMentionLine != cleanedFileContentLine {
                output.write("❌ The line \(i+1) did not match between the file \(path) and the header. Will reject it.")
                output.write("\t - Here the line \(i+1) of the header: '\(splittedMention[i])'")
                output.write("\t - Here the line \(i+1) of the current file: '\(splittedFileContent[i+1])'")
                return false
            }
        }
        
        // TODO: Deal with end by //
        if splittedFileContent.last?.clear() != "*/" {
            output.write("⚠️  It seems this Swift file (\(path)) has its header closed by another symbol than */")
        }
        
        return true
        
    }

}
