class BankerRunner < Runner
  VERSION = '0.0.1'
  
  def initialize(arguments, command)
    @arguments = arguments
    @command = command
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
    return false if @arguments.size < 1
    return File.exists?(@arguments.first)
  end

  def output_usage
    usage =   ["Usage:"]
    usage <<  ["ruby [path...]/run [file name...] [-v |-d | ]"]
    puts usage.join("\n\t")
  end

  def process_command
    @command.run(@arguments)
  end

end
