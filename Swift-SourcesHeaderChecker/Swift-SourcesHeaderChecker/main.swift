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


/// Program which has the aim of checking if all source files contain in the top of them the
/// legal notices like copyrights or licenses mentions.
/// Indeed we might need to be sure all the source code included in a project has the legal mentions headerslike
/// so as to be compliant with open source for example.
///
///
/// Program exists:
///     - (-1): something wrong occured (command line options for example)
///     - (0): no error appeared, normal exit without image processing (e.g. display help)
///     - (+1): normal exit but failure occured during check of files (i.e. at least 1 file does not leag notice ehader)
///     - (+2): normal exit, all files contain the legal mention
///
/// - Author: Pierre-Yves Lapersonne
/// - Version: 1.1.0
/// - Since: 01/07/2019
///

import Foundation

// Mark: - Configuration

public let VERSION = "2.0.0"
public var VERBOSE = false

private let consoleWritter = ConsoleOutput()
private let argumentsParser = ConsoleArgumentsParser()

// Mark: - Deal with options

consoleWritter.printWelcome()

let parameters = ConsoleInput().processProgram(arguments: &CommandLine.arguments)

guard argumentsParser.areWellDefined(arguments: parameters) else {
    consoleWritter.printBadCommandLineErrorMessage()
    exit(-1)
}

if argumentsParser.isForHelp(arguments: parameters) {
    consoleWritter.printUsage()
    consoleWritter.printBye()
    exit(0)
}

if argumentsParser.isForVersion(arguments: parameters) {
    consoleWritter.printVersion()
    consoleWritter.printBye()
    exit(0)
}

if argumentsParser.isDefined(.verbose, in: parameters) {
    VERBOSE = true
}

// Mark: - Check parameters

let folderToProcess = parameters.filter { $0.0 == .folderToProcess }[0].1

if folderToProcess.isEmpty {
    consoleWritter.write("The folder to process is undefined", to: .error)
    exit(-1)
}

if !FileManager.default.fileExists(atPath: folderToProcess) {
    consoleWritter.write("The folder to process does not exist, please check its path", to: .error)
    exit(-1)
}

let headerContentFile = parameters.filter { $0.0 == .headerContent }[0].1

if headerContentFile.isEmpty {
    consoleWritter.write("The path containing the header content to look for is undefined", to: .error)
    exit(-1)
}

if !FileManager.default.fileExists(atPath: headerContentFile) {
    consoleWritter.write("The file containing the header to look for does not exist, please check its path", to: .error)
    exit(-1)
}

var headerContent = ""

do {
    headerContent = try String(contentsOf: URL(fileURLWithPath: headerContentFile), encoding: .utf8)
} catch let error {
    ConsoleOutput().write("Something bad occured during header file read: \(error.localizedDescription)",
        to: .error)
    exit(-1)
}

let ignoreLines = Int(parameters.filter { $0.0 == .ignoringLines }[0].1) ?? -1

if ignoreLines == -1 {
    consoleWritter.write("The number of liens to ignore is not well defined. Must be a positive or nul integer", to: .error)
    exit(-1)
}

// Mark: - Core logic

consoleWritter.write("""
Will look in folder '\(folderToProcess)' for mention in file '\(headerContentFile)' ignoring '\(ignoreLines)' lines
""", to: .standard)

let areAllResourcesSuitable = SourcesHeaderChecker("swift")
    .lookIn(folder: folderToProcess, for: headerContent, ignoring: ignoreLines)

// Mark: - Check of results

if !areAllResourcesSuitable {
    consoleWritter.write("🚨 FAILURE 🚨: There is at least one file without expected header")
    consoleWritter.printBye()
    exit(1)
} else {
    consoleWritter.write("✅ SUCCESS ✅: All files contain the expected header")
    consoleWritter.printBye()
    exit(2)
}


