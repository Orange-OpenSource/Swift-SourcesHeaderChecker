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

/// Structure to use so as to parse raw parameters given to the command line in console mode
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 01/07/2019
///
struct ConsoleArgumentsParser {
    
    /// Checks if the arguments given in parameters of the command are well written and can be used, or not
    /// - Returns: A flag indicating of parameters canot be used (false) or can be (true)
    ///
    func areWellDefined(arguments params: [(ConsoleArgumentTypes, String)]) -> Bool {
        
        if isForHelp(arguments: params) {
            return true
        }
        
        if isForVersion(arguments: params) {
            return true
        }
        
        if params.count != 3 && params.count != 4 {
            return false
        }
        
        if !(isDefined(.folderToProcess, in: params)
            && isDefined(.headerContent, in: params)
            && isDefined(.ignoringLines, in: params)) {
            return false
        }
        
        if params.count == 4 && !isDefined(.verbose, in: params) {
            return false
        }
        
        return true

    }
    
    /// Returns true if the option is for help message to display or false otherwise
    /// - Returns: A boolean value
    ///
    func isForHelp(arguments params: [(ConsoleArgumentTypes, String)]) -> Bool {
        return (params.count == 1 && params[0].0 == .help)
    }
    
    /// Returns true if the option is for version message to display or false otherwise
    /// - Returns: A boolean value
    ///
    func isForVersion(arguments params: [(ConsoleArgumentTypes, String)]) -> Bool {
        return (params.count == 1 && params[0].0 == .version)
    }
    
    /// Return if there is a defined option in the arguments (true) or not (false)
    /// - Parameters:
    ///     - option: The option to look for
    ///     - arguments: The bundle of arguments to parse
    /// - Returns: A boolean value
    ///
    func isDefined(_ option: ConsoleArgumentTypes, in arguments: [(ConsoleArgumentTypes, String)])
        -> Bool {
        return arguments.filter { $0.0 == option }.count == 1
    }
    
}
