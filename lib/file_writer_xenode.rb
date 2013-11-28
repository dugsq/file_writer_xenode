# Copyright Nodally Technologies Inc. 2013
# Licensed under the Open Software License version 3.0
# http://opensource.org/licenses/OSL-3.0

# Version 0.1.1
#
# File Writer Xenode** reads its input message context and writes the input message data to a specified 
# local folder. The path to write the file to will be read from the input data context, and if one does 
# not exist, it will use the path specified in the configuration file.
#
# Configuration file options:
#   loop_delay: defines number of seconds the Xenode waits before running process(). Expects a float. 
#   enabled: determines if this Xenode process is allowed to run. Expects true/false.
#   debug: enables extra debug messages in the log file. Expects true/false.
#   dir_path: defines the local path to save the file. Expects a string.
#   file_mode: Input/Output Open Mode. Expects a string. For more information, refer to: 
#   http://ruby-doc.org/core-2.0.0/IO.html#method-c-new-label-IO+Open+Mode
#
# Example Configuration File:
#   enabled: true
#   loop_delay: 60
#   debug: false
#   dir_path: "@disk_dir/inbound"
#   file_mode: "a" 
#
# Example Input:     
#   msg.context: [{:dir_path=>"/temp/hello.txt",:file_name=>"hello.txt"}] 
#   msg.data:  "This string contains the actual file content to be written to a local file"
#
# Example Output:   
#   The File Writer Xenode does not generate any output.
#

class FileWriterXenode
  include XenoCore::XenodeBase
  
  # this method get call once as the Xenode is initialized
  # it is called inside the main eventmachine loop
  def startup()
    mctx = "#{self.class}.#{__method__} [#{@xenode_id}]"
    
    # this will always be logged as the force logging parameter is true
    do_debug("#{mctx} - config: #{@config.inspect}")
    
    # default if config not supplied
    @config ||= {}
    
  end
  
  def process_message(msg)
    mctx = "#{self.class}.#{__method__} [#{@xenode_id}]"
    begin
      # make sure there is an actual message as the system will read the
      # xenode's message queue on startup
      if msg
                
        # get the file_path from the message context
        fp = get_file_path(msg.context)
        
        # set file over write or append mode
        fmode = @config[:file_mode]
        fmode ||= "w"
                
        if msg.data
          File.open(fp, fmode) { |f|
             f.write(msg.data)
           }
          do_debug("#{mctx} writing file: #{fp.inspect}", true)
        end
        
      end
    rescue Exception => e
      catch_error("#{mctx} - ERROR #{e.inspect}")
    end
  end
  
  def get_file_path(context)
    mctx = "#{self.class}.#{__method__} [#{@xenode_id}]"
    ret_val = nil
    begin
      
      dir_path = nil
      file_name = nil
      
      # get the file_name
      file_name = get_file_name(context)
      
      do_debug("#{mctx} file_name: #{file_name.inspect}", true)
      
      # get the dir_path from the context
      dir_path = context['dir_path'] if context && context.is_a?(Hash)
      
      # resolve tokens in path ('@this_node' or '@this_server')
      dir_path = resolve_sys_dir(dir_path) if dir_path
      
      # set the default dir_path from config if none provided in context
      dir_path ||= resolve_sys_dir(@config[:dir_path])
      
      # set the default dir_path if none provided in config
      dir_path ||= resolve_sys_dir("@this_node")
      
      # ensure the directroy exists
      FileUtils.mkdir_p(dir_path) unless dir_path.to_s.empty?
      
      # join the path and file_name
      ret_val = File.join(dir_path, file_name)
      
    rescue Exception => e
      catch_error("#{mctx} - ERROR #{e.inspect}")
    end
    ret_val
  end
  
  def get_file_name(context)
    mctx = "#{self.class}.#{__method__} [#{@xenode_id}]"
    
    file_name = nil
    stamp = nil
    
    # get the file_name from the config
    file_name = @config[:file_name]
    
    # get filename from message context overrride config
    file_name = context[:file_name] if context && context[:file_name]
    
    # resolve the timestamp if any
    if file_name && file_name.to_s.include?("|TIMESTAMP|")
      stamp_format = @config[:stamp_format]
      stamp_format ||= "%Y%m%d%H%M%S%4N"
      file_name = file_name.gsub("|TIMESTAMP|", Time.now.strftime(stamp_format))
    end
      
    # set a default filename if none provided in the config
    file_name ||= "#{@xenode_id}_#{Time.now.strftime('%Y%m%d%H%M%S%4N')}_in"
        
    file_name
  end
end
