module Scheduling
  class OS
  
    attr_reader :parser, :scheduler
    attr_accessor :cpu_burst, :io_burst, :processes, :running_process, :ready_queue, :cycles, :io_cycles

    def initialize(scheduler = nil, processes = [])
      @scheduler  = scheduler
      @processes  = processes
      RandomNumberGenerator.clear!
    end

    def random_os(interval)
      1 + (RandomNumberGenerator.number % interval)
    end

    def run
      @cycles = 0
      @io_cycles = 0
      while !terminated? do
        blocked = blocked_processes
        running = running_process
        ready   = ready_processes
        
        blocked.each do |p|
          p.cycle
        end
        
        if running
          running.cycle
          running.io_burst = random_os(running.max_io) if running.blocked?
        end
        
        ready.each do |p|
          p.cycle
        end
        
        ready_processes.each do |p|
          scheduler.schedule(p)
        end

        if running_process.nil? && (running = scheduler.next_ready_process)
          running.start_run(self)
        end

        @io_cycles += 1 if blocked_processes.any?
        @cycles += 1    unless terminated?
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
      processes.select { |p| p.ready? || p.arrival_time == cycles }
    end
    
    def finishing_time
      @cycles
    end
    
    def cpu_utilization
      process_sum(:cpu_time).to_f / finishing_time
    end

    def io_utilization
      io_cycles.to_f / finishing_time
    end
    
    def throughput
      processes.size * 100.0 / finishing_time.to_f
    end
    
    def turnaround_time
      process_sum(:turnaround_time).to_f / processes.size
    end
    
    def wait_time
      process_sum(:wait_time).to_f / processes.size
    end

  protected
    
    def process_sum(sym)
      processes.map { |p| p.send(sym) }.inject {|sum, n| sum + n }
    end
  end
end
