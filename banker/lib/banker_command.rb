class BankerCommand
  attr_accessor :report
  attr_reader   :parser

  def run(arguments)
    parser      = parse_processes(arguments)
    optimist    = simulate_optimist(parser.tasks, parser.resources)
    banker      = simulate_banker(parser.tasks, parser.resources)
    self.report = create_report(optimist, banker)
    self
  end

  def create_report(optimist, banker)
    BankerReport.new(optimist, banker)
  end
  
protected
  def simulate_optimist(tasks, resources)
    simulator = OptimistSimulator.new(tasks, resources)
    simulator.simulate!
    simulator.manager
  end
  
  def simulate_banker(tasks, resources)
    simulator = BankerSimulator.new(tasks, resources)
    simulator.simulate!
    simulator.manager
  end
  
  def parse_processes(file_name)
    parser = TaskParser.new(file_name)
    parser.parse
    parser
  end
  
end