#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/env.rb'

class LinkerRunner
  VERSION = '0.0.1'
  
  def initialize(arguments, stdin)
    @arguments = arguments
    @stdin = stdin
  end

  # Parse options, check arguments, then process the command
  def run
    if arguments_valid? 
      process_arguments
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
    
    def process_arguments
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

    def process_standard_input
      input = @stdin.read
      # TO DO - process input
      
      # [Optional]
      # @stdin.each do |line| 
      #  # TO DO - process each line
      #end
    end
end


# Create and run the application
app = LinkerRunner.new(ARGV, STDIN)
app.run
