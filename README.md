## FileWriterXenode
VERSION: 0.0.1

## Brief:
Writting file to the disk (where the Xnoede is hosted)

## Gems:
none

## Config:
|name|type|default|description
|---|---|---|---|
|**`dir_path`**| String | "@disk_dir" | path to save the file. You can use @disk_dir OR @tmp_dir here to direct the path
|**`file_mode`**| String | "a" | http://ruby-doc.org/core-2.0.0/IO.html#method-c-new-label-IO+Open+Mode
##### Example Config:
```
loop_delay: 0.5  # native configuration
enabled: true    # native configuration

dir_path: "@disk_dir" 
file_mode: "a"
```


## Expected In-bound Message:
#### Context:
```
```
#### Data:
```
```
#### Command:
```
```

# Contributing

https://help.github.com/articles/fork-a-repo

