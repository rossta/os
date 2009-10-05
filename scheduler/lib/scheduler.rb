class Scheduler
  
  def initialize(file_name)
    @reader = Reader.new(file_name)
  end
  
  def to_s
    "The original input was: " + process_parser.original_input
  end
  
protected

  def process_parser
    @parser = ProcessParser.new(@reader)
  end

end