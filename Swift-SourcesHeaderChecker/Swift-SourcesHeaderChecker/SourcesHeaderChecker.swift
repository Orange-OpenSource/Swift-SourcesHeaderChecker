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

/// Structure which runs the instructions to read target folder, filter files to read, and check if they
/// contain the header.
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 2.0.0
/// - Since: 01/07/2019
///
struct SourcesHeaderChecker {
    
    // Mark: - Variables
    
    /// The filter to use for the files to check
    private let ressourcesFilter: String
    
    
    // Mark: - Cnostructor
    
    /// Initializes the regular expression to use so as to filter the files extensions
    /// and keep only these we want to check
    /// - Parameters:
    ///     - filter: The regular expression to apply, e.g "swift|sh"
    ///
    init(_ filter: String) {
        ressourcesFilter = filter
    }
    
    
    // Mark: - Methods
    
    /// Looks recursively in the target folder for source files with extension, and check
    /// for these files if they have in their top the header with legal mentions.
    /// - Parameters:
    ///     - folder: The target folder to start looking
    ///     - notice: The notice/header to look for
    ///     - ignoring: The number of lines to ignore starting from the top of the processed file
    /// - Returns:
    ///     - A flag indicating if at least one file does not contain the suitable header (false) or if
    /// all the files are suitable (true)
    ///
    func lookIn(folder target: String, for notice: String, ignoring lines: Int) -> Bool {
        
        // Get files to verify
        // FIXME: May be quite heavy for too big projects
        let matchingRessources = FolderCrawler().crawlIn(folder: target, filtering: ressourcesFilter)
        
        // Make the controls
        let areAllResourcesSuitable = HeaderVerifier()
            .look(at: matchingRessources, for: notice, ignoring: lines)
        
        return areAllResourcesSuitable
        
    }
    
}
