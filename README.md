# Swift-SourcesHeaderChecker

Swift program which checks if source files contain the legal mention header in the top of them.
This program can be used so as to be sure the sources contain the notices like copyrights or licenses.


## Managed files

This current version deals only with Swift file (with .swift extensions).
In assertions, we will assume the legal notice started with "/*" or "/*\*" and ends with "\*/".


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

To run the program where it have to find recursively in FOLDER the source files to check if they contain headers defined in FILE_CONTENT (path to the plain text file):

```shell
EXECUTABLE --folder FOLDER --header FILE_CONTENT
```

You can also make the program display more messages with the verbose option:

```shell
EXECUTABLE --folder FOLDER --mention FILE_CONTENT --verbose
```


## Example

Running the program _Swift-SourcesHeaderChecker_ starting from folder at _src_ looking for header defined in the _LICENSE.txt_:

```shell
Swift-SourcesHeaderChecker --folder "./src" --header "./LICENSE.txt"
```


## What is done

Basically the program deals only with Swift files.  
For each .swift file in the target folder, will keep as much lines as these defined in the mention file.
Will check if the header starts by /** or /* and end with \*/.
To make easier the comparison, removes " ", "\n", "\r", "\t" symbols for each line to compare but will keep empty lines.
If a line of the on-process file does not match to the line of the mention file, the file will be rejected.


## Incoming features

This project may be able in the future to deal with Shell, Objective-C, Python or Ruby files.  
Moreover it would be possible to deal with several licenses (with several copyrights or third-party tools mentions).  
Maybe integration with Cocoapods or Fastlane.  

Feel free to make pull requests :)
