# Swift-SourcesHeaderChecker

Swift program which checks if source files contain the legal mention header in the top of them.
This program can be used so as to be sure the sources contain the notices like copyrights or licenses.


## Managed files

This current version deals only with Swift file (with .swift extensions).
In assertions, we will assume the legal notice started with "/*", "/*\*"  or "//" and ends with "\*/" or "//".


## Executables

If you are looking for the executables you can have a look on folder _~/Library/Developer/Xcode/DerivedData/Swift-SourcesHeaderChecker-XXX/Build/Products/Debug/_ where XXX is a kind of random string generated by Xcode. You have to build the project with Xcode before. Place the executable wherever you want.


## Run the program

Assuming _EXECUTABLE_ is the executable file (you can pick for example in the mentioned folder above):

To get the usage of the program:

```shell
EXECUTABLE --help
```

To get the version of the program:

```shell
EXECUTABLE --version
```

To run the program where it have to find recursively in FOLDER the source files to check if they contain headers defined in FILE_CONTENT (path to the plain text file) ignoring first LINES lines:

```shell
EXECUTABLE --folder FOLDER --header FILE_CONTENT --ignoring LINES
```

You can also make the program display more messages with the verbose option and an exclusion list ignoring files defined in LIST:

```shell
EXECUTABLE --folder FOLDER --header FILE_CONTENT --ignoring LINES --excluding LIST --verbose
```


## Examples

Running the program _Swift-SourcesHeaderChecker_ starting from folder at _src_ looking for header defined in the _LICENSE.txt_, ignoring first 2 lines because they contain some noise (e.g. file name), ignoring files of _excluding-list.txt_ (e.g. because they are generated):

```shell
Swift-SourcesHeaderChecker --folder "./src" --header "./LICENSE.txt" --ignoring 2 --excluding "excluding-list.txt"
```

Running the program _Swift-SourcesHeaderChecker_ starting from folder at _src_ looking for header defined in the _LICENSE.txt_, ignoring first 2 lines because they contain some noise (e.g. file name), in verbose mode, without exclusion list:

```shell
Swift-SourcesHeaderChecker --folder "./src" --header "./LICENSE.txt" --ignoring 2 --verbose
```


## What is done

Basically the program deals only with Swift files.  
For each .swift file in the target folder, will keep as much lines as these defined in the mention file and may get rid of some lines to ignore.
Will check if the header starts by /** , /*  or // and end with \*/ or //.
To make easier the comparison, removes " ", "\n", "\r", "\t", "//" symbols for each line to compare but will keep empty lines.
If a line of the on-process file does not match to the line of the mention file, the file will be rejected.


## Incoming features

This project may be able in the future to deal with Shell, Objective-C, Python or Ruby files.  
Moreover it would be possible to deal with several licenses (with several copyrights or third-party tools mentions).  
Maybe integration with Cocoapods or Fastlane.  

Feel free to make pull requests :)


## Exit codes

The program returns a value indicating if a problem occured or not:

* (-1): something wrong occured (command line options for example)
* (0): no error appeared, normal exit without file processing (e.g. display help)
* (+1): normal exit but failure occured during check of files (i.e. at least 1 file does not have legal notice header)
* (+2): normal exit, all source files contain the legal notices


## Xcode integration

You can use this tool with an Xcode build script. The following sample can be placed in a script to add to your Xcode configuration. Thus the tool (with binary in the project) can be used easily.

```shell
#!/bin/sh
TOOL_PATH="path/to/binary/of/this/tool"
TARGET_FOLDER="."
HEADER_TEMPLATE="./LICENSE.txt"
IGNORE=2
EXCLUSIONS="path/to/exclusion/file.txt"

$TOOL_PATH --folder "$TARGET_FOLDER" --header "$HEADER_TEMPLATE" --ignoring "$IGNORE" --excluding "$EXCLUSIONS"
result=$?

if [ $result -eq 2 ]
then
	echo "✅ All source files contain legal notice."
	exit 0
else
	echo "🔴 Something wrong occured, see logs for further details."
	exit 1
fi
```

## Who uses it?

* Baah box project (Orange SA) - iOS app: https://github.com/Orange-OpenSource/BaahBox-iOS


