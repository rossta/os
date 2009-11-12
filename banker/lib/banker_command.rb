class BankerCommand
  attr_accessor :reports
  attr_reader   :parser

  def run(arguments)
    if arguments.is_a?(Array)
      file_name = arguments.first
      Logger.debug(arguments.last == "-v" || arguments.last == "--verbose")
    else
      file_name = arguments
      Logger.debug(false)
    end
    Logger.info "\n---OPTIMIST RUN---"
    Logger.info "\n"
    optimist    = run_optimist(file_name)
    Logger.info "\n---BANKER RUN---"
    Logger.info "\n"
    banker      = run_banker(file_name)
    Logger.info "\n---OUTPUT---"
    Logger.info "\n"
    to_s
  end
  
  def run_banker(arguments)
    parser      = parse_processes(arguments)
    banker      = simulate_banker(parser.tasks, parser.resources)
    report      = create_report(banker)
    self.reports << report
  end
  
  def run_optimist(arguments)
    parser      = parse_processes(arguments)
    optimist    = simulate_optimist(parser.tasks, parser.resources)
    report      = create_report(optimist)
    self.reports << report
  end

  def create_report(manager)
    ManagerReport.new(manager)
  end
  
  def reports
    @reports ||= []
  end
  
  def to_s
    reports.map{ |r| r.to_s }.join("\n\n")
  end
  
protected
  def simulate_optimist(tasks, resources)
    optimist = Optimist.new(tasks)
    simulator = Simulator.new(optimist, resources)
    simulator.simulate!
    simulator.manager
  end
  
  def simulate_banker(tasks, resources)
    banker = Banker.new(tasks)
    simulator = Simulator.new(banker, resources)
    simulator.simulate!
    simulator.manager
  end
  
  def parse_processes(file_name)
    parser = TaskParser.new(file_name)
    parser.parse
    parser
  end
  
end