File Writer Xenode
=====================

Note: you will need the Xenograte Community Toolkit (XCT) to run this Xenode. Refer to the XCT repo [https://github.com/Nodally/xenograte-xct](https://github.com/Nodally/xenograte-xct) for more information.

**File Writer Xenode** reads its input message context and writes the input message data to a specified local folder. The path to write the file to will be read from the input data context, and if one does not exist, it will use the path specified in the configuration file.

###Configuration file options:
* loop_delay: defines number of seconds the Xenode waits before running process(). Expects a float. 
* enabled: determines if this Xenode process is allowed to run. Expects true/false.
* debug: enables extra debug messages in the log file. Expects true/false.
* dir_path: defines the local path to save the file. Expects a string.
* file_mode: Input/Output Open Mode. Expects a string. For more information, refer to: http://ruby-doc.org/core-2.0.0/IO.html#method-c-new-label-IO+Open+Mode
* [Click Here](https://github.com/Nodally/xenograte-xct/wiki/building-a-xenode#default-config-file) for more information on Xenode Configuration

###Example Configuration File:
* enabled: true
* loop_delay: 60
* debug: false
* dir_path: "@disk_dir/inbound"
* file_mode: "a" 

###Example Input:     
* msg.context: [{:dir_path=>"/temp/hello.txt",:file_name=>"hello.txt"}] 
* msg.data:  "This string contains the actual file content to be written to a local file"

###Example Output:   
* The File Writer Xenode does not generate any output.


