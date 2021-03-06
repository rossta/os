module Scheduling
  class OS
    def self.boot(scheduler, processes, flag = nil)
      @@instance = new(scheduler, processes, flag)
    end

    def self.instance
      @@instance ||= new
    end

    def self.run
      instance.run
    end
    
    def self.random_os(interval, state = nil)
      random = RandomNumberGenerator.number
      instance.details << "Burst when choosing #{state.to_s} process to run: #{random}" if instance.verbose?
      1 + (random % interval)
    end

    attr_reader :scheduler
    attr_accessor :details, :states

    def initialize(scheduler = nil, processes = [], output_flag = nil)
      @scheduler    = scheduler
      @output_flag  = output_flag
      ProcessTable.load_processes(processes)
      RandomNumberGenerator.clear!
    end

    def run
      Clock.start
      while !terminated? do
        record_details

        processes_to_cycle.each { |p| p.cycle }
        
        scheduler.schedule_ready_processes

        scheduler.run_next_process

        cycle_clock
      end
    end
    
    def details
      @details ||= []
    end

    def states
      @states ||= []
    end
    
    def verbose?
      @verbose ||= (@output_flag == "-v" || @output_flag == "--verbose")
    end
    
    def detailed?
      @detailed ||= (@output_flag == "-d" || @output_flag == "--detailed") || verbose?
    end

    protected
    
    def record_details
      return unless detailed? || verbose?
      states << ProcessTable.current_state.join("")
      details << format("%-24s", "Before cycle #{Clock.time}:") + states.last
    end
    
    def processes_to_cycle
      (blocked_processes + [running_process] + ready_processes).compact
    end
    
    def cycle_clock
      Clock.cycle_io    if blocked_processes.any?
      Clock.cycle       unless terminated?
    end
    
    def terminated?
      ProcessTable.terminated?
    end
    
    def running_process
      ProcessTable.running_process
    end
    
    def blocked_processes
      ProcessTable.blocked_processes
    end
    
    def ready_processes
      ProcessTable.ready_processes
    end

  end
end
