class Scheduler
  attr_reader :parser
  
  def initialize(file_name)
    @parser = ProcessParser.new(file_name)
    @processes = parse_processes
  end
  
  def schedule
    raise "Subclass must implement"
  end
  
  def to_s
    "The original input was: " + process_parser.original_input
  end
  
protected

  def parse_processes
    parser.parse
    parser.processes
  end

end