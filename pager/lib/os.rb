module Paging
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
      Logger.info "Burst when choosing #{state.to_s} process to run: #{random}"
      1 + (random % interval)
    end

    attr_accessor :details

    def initialize(processes = [])
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
