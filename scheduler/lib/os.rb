module Scheduling
  class OS
    def self.boot(scheduler, processes)
      @@instance = Scheduling::OS.new(scheduler, processes)
    end
    
    def self.instance
      @@instance ||= Scheduling::OS.new
    end

    def self.run
      instance.run
    end

    def self.random_os(interval, state = nil)
      random = RandomNumberGenerator.number
      instance.details << "Burst when choosing #{state.to_s} process to run: #{random}"
      1 + (random % interval)
    end
    
    attr_reader :parser, :scheduler
    attr_accessor :cpu_burst, :io_burst, :processes, :ready_queue, :details

    def initialize(scheduler = nil, processes = [])
      @scheduler  = scheduler
      @processes  = processes
      RandomNumberGenerator.clear!
    end
    
    def run
      Clock.start
      while !terminated? do
        record_details
        ready_at_start = ready_processes
        
        blocked_processes.each { |p| p.cycle }
        
        running_process.cycle if running_process
        
        ready_at_start.each { |p| p.cycle }
        
        ready_processes.each { |p| scheduler.schedule(p) } 

        scheduler.run_next_process if running_process.nil?
        
        Clock.cycle_io    if blocked_processes.any?
        Clock.cycle       unless terminated?
      end
    end

    def terminated?
      processes.all? { |p| p.terminated? }
    end

    def running_process
      processes.detect { |p| p.running? }
    end
    
    def blocked_processes
      processes.select { |p| p.blocked? }
    end
    
    def ready_processes
      processes.select { |p| p.ready? || p.arrival_time == Clock.time }
    end
    
    def cpu_utilization
      process_sum(:cpu_time).to_f / Clock.time
    end

    def io_utilization
      Clock.io_time.to_f / Clock.time
    end
    
    def throughput
      processes.size * 100.0 / Clock.time.to_f
    end
    
    def turnaround_time
      process_sum(:turnaround_time).to_f / processes.size
    end
    
    def wait_time
      process_sum(:wait_time).to_f / processes.size
    end
    
    def record_details
      process_state = processes.map { |p| p.current_state }
      details << "Before cycle #{Clock.time}:  " + process_state.join("\t")
    end

    def details
      @details ||= []
    end

  protected
    
    def process_sum(sym)
      processes.map { |p| p.send(sym) }.inject {|sum, n| sum + n }
    end
    
  end
end
