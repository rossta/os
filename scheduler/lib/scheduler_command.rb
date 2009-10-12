class SchedulerCommand
  attr_accessor :report

  def run(arguments)
    simulate(arguments)
    puts report.to_s
  end

  def simulate(arguments)
    file_name = arguments.shift
    strategy  = arguments.shift
    flag      = arguments.shift

    parser = parse_processes(file_name)
    scheduler = get_scheduler(strategy)
    
    Scheduling::OS.boot(scheduler, parser.sorted_processes)
    Scheduling::OS.run
    @report = Scheduling::Report.new(Scheduling::OS.instance, parser, flag).report
  end

  protected

  def parse_processes(file_name)
    parser = ProcessParser.new(file_name)
    parser.parse
    parser
  end
  
  def get_scheduler(strategy)
    case strategy.to_sym
    when :rr
      RoundRobinScheduler.new
    when :fifo
      FifoScheduler.new
    else
      FifoScheduler.new
    end
  end
end