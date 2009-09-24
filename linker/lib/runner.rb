#!/usr/bin/env ruby

class Runner
  VERSION = '0.0.1'
  
  def initialize(arguments)
    @arguments = arguments
  end

  def run
    if arguments_valid? 
      process_command
    else
      output_usage
    end
      
  end
  
protected

  def arguments_valid?
    if @arguments.length == 1
      return File.exists?(@arguments.first)
    else
      false
    end
  end
  
  def output_version
    puts "#{File.basename(__FILE__)} version #{VERSION}"
  end
  
  def output_usage
    puts "Usage: Please enter valid file name"
  end
  
  def process_command
    linker = Linker.new(@arguments.first)
    linker.link
    puts linker.to_s
  end

end
