class SchedulerCommand
  attr_accessor :report
  
  def run(arguments)
    parser = ProcessParser.new(arguments.first)
    parser.parse
    
    os = Scheduling::OS.new(FifoScheduler.new, parser.processes)
    os.run
    
    @report = Scheduling::Report.new(os, parser).report
  end
end