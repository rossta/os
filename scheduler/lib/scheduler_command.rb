class SchedulerCommand
  attr_accessor :report

  def run(arguments)
    simulate(arguments)
    puts report_display
  end

  def simulate(arguments)
    file_name = arguments.shift
    strategy  = arguments.shift
    flag      = arguments.shift

    parser = parse_processes(file_name)
    scheduler = get_scheduler(strategy)
    
    Scheduling::OS.boot(scheduler, parser.sorted_processes)
    Scheduling::OS.run
    self.report = Scheduling::Report.new(Scheduling::OS.instance, parser, flag)
  end
  
  def report_display
    report.report
  end
  
  def states
    report.states
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
      Scheduling::RoundRobinScheduler.new
    when :psjf
      Scheduling::ShortestRemainingScheduler.new
    when :hprn
      Scheduling::HighestPenaltyScheduler.new
    when :fifo || :fcfs
      Scheduling::FifoScheduler.new
    else
      Scheduling::FifoScheduler.new
    end
  end
end