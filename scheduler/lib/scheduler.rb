class Scheduler
  attr_reader :parser
  attr_accessor :cpu_burst, :io_burst, :processes, :running_process, :ready_queue

  def initialize(file_name)
    @parser       = ProcessParser.new(file_name)
    @processes    = parse_processes
  end

  def run
    while !terminated? do
      # if running_process.nil? || running_process.terminated?
      #   next_ready_process.cpu_burst  = os.random_os(running_process.max_cpu)
      # elsif running_process.blocked?
      #   running_process.io_burst      = os.random_os(running_process.max_io)
      #   next_ready_process.cpu_burst  = os.random_os(running_process.max_cpu)
      # end
      # 
      # processes.each do |p|
      #   p.cycle
      # end
      
      # add newly ready processes to ready queuq

      cycle += 1
    end
  end

  def next_ready_process
    # ready_queue.pop
  end

  def cycle
    @cycle ||= 0
  end

  def terminated?
    processes.all? { |p| p.terminated? }
  end

  def running_process
    processes.detect { |p| p.running? }
  end

  def to_s
    text = ["The original input was: " + parser.to_s]
    text << "The (sorted) input is: " + parser.to_s
    text << "\n"
    @processes.each_with_index do |p, i|
      process_text = ["Process #{i}:"]
      process_text << "    " + p.data
      text << process_text.join("\n")
    end
    text.join("\n")
  end

protected

  def parse_processes
    parser.parse
    parser.processes
  end

  def os
    @os ||= Scheduling::OS.new
  end

end