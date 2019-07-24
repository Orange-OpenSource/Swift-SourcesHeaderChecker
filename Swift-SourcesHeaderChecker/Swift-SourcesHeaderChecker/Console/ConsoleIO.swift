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

/// Structure to use so as to write in output channels some messages
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 01/07/2019
///
struct ConsoleOutput {
    
    /// Displays a welcome message
    ///
    func printWelcome() {
        write("*************************************************************************")
        write("* Swift-SourcesHeaderChecker                                            *")
        write("* Copyright (C) 2019 Orange SA                                          *")
        write("* MIT License                                                           *")
        write("* Version: \(VERSION)                                                        *")
        write("* Check easily in sources files contain legal notices in headers        *")
        write("*************************************************************************")
    }
    
    /// Displays the exit common message
    ///
    func printBye() {
        write("Execution completed, bye!")
    }
    
    /// Displays in the standard output the usage of the program
    ///
    func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        write("Usage:")
        write("\t\(executableName) --folder path --header content [--verbose]")
        write("\t\t - path: The path to the root folder containing the source files to process")
        write("\t\t - content: The path to the file containing the header content to look for, raw string, without any glue like /** /// <!--")
        write("or")
        write("\t\(executableName) --help")
        write("\t\t To display this help message")
        write("or")
        write("\t\(executableName) --version")
        write("\t\t To display the version of the program")
    }
    
    /// Displays in the standard output the version of the program
    ///
    func printVersion() {
        write("Version: \(VERSION)")
    }
    
    /// Prints error message with more details
    ///
    func printBadCommandLineErrorMessage() {
        write("Command line not written as expected", to: .error)
        printUsage()
        printBye()
    }
    
    /// Writes in the selected output the message
    /// - Parameters:
    ///     - message: The message to write
    ///     - to: The output to use
    ///
    func write(_ message: String, to: OutputTypes = .standard) {
        switch to {
        case .standard:
            print("\(message)")
        case .error:
            fputs("💥 Error: \(message)\n", stderr)
        }
    }
    
    /// Writes the message in the channel if the VERBOSE flag is enabled
    /// - Parameters:
    ///     - message: The message to write
    ///     - to: The output to use
    ///
    func verbose(_ message: String, to: OutputTypes = .standard) {
        if VERBOSE {
            write(message, to: to)
        }
    }
    
}

/// Structure to use so as to read console entries or arguments
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.0.0
/// - Since: 01/07/2019
///
struct ConsoleInput {
    
    /// Process the bundle of arguments given to the program and check their values.
    /// Arguments must be a 5-length array or a 2-length array.
    /// Item 0 of this array is the program name, other elements are the parameters.
    ///
    /// - Parameters:
    ///     - arguments: The bunch of arguments of the program
    /// - Returns:
    ///     - An array of tuples containing the argument type and its value
    ///
    func processProgram(arguments args: inout [String]) -> [(ConsoleArgumentTypes, String)] {
        
        let argsCount = args.count
        
        if argsCount == 2 && args[1] == "--help" {
            return [(ConsoleArgumentTypes.help, "")]
        }
        
        if argsCount == 2 && args[1] == "--version" {
            return [(ConsoleArgumentTypes.version, "")]
        }
        
        let expectedMinimalNumberOfArguments = 5
        if argsCount != expectedMinimalNumberOfArguments
            && argsCount != (expectedMinimalNumberOfArguments + 1){ // + 1 -> maybe add of --verbose
            return [(ConsoleArgumentTypes.undefined, "")]
        }
        
        var options: [(ConsoleArgumentTypes, String)] = []
        if  isVerboseDefined(in: args) {
            options.append((.verbose, ""))
            args = args.filter { $0 != "--verbose" }
        }
        
        for index in stride(from: 1, to: argsCount-1, by: 2 ){
            let option = ConsoleArgumentTypes(value: args[index])
            guard option != .undefined else {
                return [(option, "")]
            }
            if option != .verbose {
                options.append((option,args[index+1]))
            }
        }
        
        return options
        
    }
    
    /// Checks if the verbose option has been added oe not
    /// - Returns:
    ///     - a boolean value, true if available false otherwise
    ///
    private func isVerboseDefined(in arguments: [String]) -> Bool {
        return  arguments.filter { $0 == "--verbose" }.count == 1
    }
    
}
