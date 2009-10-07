module Scheduling
  class OS
  
    attr_reader :parser, :scheduler
    attr_accessor :cpu_burst, :io_burst, :processes, :running_process, :ready_queue, :cycles

    def initialize(scheduler = nil, processes = [])
      @scheduler  = scheduler
      @processes  = processes
    end

    def random_os(interval)
      1 + (generator.number % interval)
    end

    def run
      cycles = 0
      while !terminated? do
        processes.each do |p|
          p.cycle
          scheduler.schedule(p)
        end
        
        if running_process.nil? || running_process.terminated?
          next_running_process = scheduler.next_ready_process
          next_running_process.cpu_burst  = random_os(next_running_process.max_cpu) if next_running_process
        end
        
        if !blocked_process.nil?
          blocked_process.io_burst      = random_os(blocked_process.max_io)
        end
        
        cycles += 1
      end
    end

    def terminated?
      processes.all? { |p| p.terminated? }
    end

    def running_process
      processes.detect { |p| p.running? }
    end
    
    def blocked_process
      processes.detect { |p| p.blocked? }
    end
    

  protected
    def generator
      @generator ||= RandomNumberGenerator.new
    end
  end
end
