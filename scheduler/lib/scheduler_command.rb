class SchedulerCommand
  attr_accessor :report
  
  def run(arguments)
    simulate(arguments)
    puts report.to_s
  end
  
  def simulate(arguments)
    parser = ProcessParser.new(arguments.first)
    parser.parse
    
    os = Scheduling::OS.new(FifoScheduler.new, parser.processes)
    os.run
    @report = Scheduling::Report.new(os, parser, arguments[1]).report
  end
end