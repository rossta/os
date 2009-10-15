class SchedulerRunner < Runner
  VERSION = '0.0.1'
  VALID_TYPES = %w|fcfs fifo rr psjf hprn|
  
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
    return false if @arguments.size < 2
   return File.exists?(@arguments.first) && VALID_TYPES.include?(@arguments[1])
  end

  def output_usage
    usage =   ["Usage:"]
    usage <<  ["ruby [path...]/run.rb [file name...] [scheduler type ...] [-v |-d | ]"]
    usage <<  ["scheduler types: fcfs | rr | psjf | hprn "]
    usage <<  ["optional flags : -d | --detailed | -v | --verbose "]
    puts usage.join("\n\t")
  end

  def process_command
    @command.run(@arguments)
  end

end
