class SchedulerCommand
  attr_accessor :report
  
  def run(arguments)
    simulate(arguments)
    puts report.to_s
  end
  
  def simulate(arguments)
    parser = ProcessParser.new(arguments.first)
    parser.parse
    
    Scheduling::OS.boot(FifoScheduler.new, parser.sorted_processes)
    Scheduling::OS.run
    @report = Scheduling::Report.new(Scheduling::OS.instance, parser, arguments[1]).report
  end
end