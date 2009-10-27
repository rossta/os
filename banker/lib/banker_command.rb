class BankerCommand
  attr_accessor :report

  def run(arguments)
    parse(arguments)
  end

  def simulate(arguments)
    self.report = BankerReport.new(Optimist.new, Banker.new)
  end
  
  def parse(arguments)
    parser = parse_processes(file_name)
  end
  
  protected

  def parse_processes(file_name)
    parser = TaskParser.new(file_name)
    parser.parse
    parser
  end
  
end