module Paging
  class ProcessTable
    def self.load_processes(processes = [])
      instance.processes = processes
    end

    def self.instance
      @@instance ||= new
    end

    def self.processes
      instance.processes
    end

    def self.clear!
      @@instance = new
    end

    def self.terminated?
      processes.all? { |p| p.terminated? }
    end

    def self.running_process
      processes.detect { |p| p.running? }
    end
    
    def self.blocked_processes
      processes.select { |p| p.blocked? }
    end
    
    def self.ready_processes
      processes.select { |p| p.ready? || p.arrival_time == Clock.time }
    end
    
    def self.sum(sym)
      processes.map { |p| p.send(sym) }.inject {|sum, n| sum + n }
    end
    
    def self.size
      processes.size
    end
    
    def self.current_state
      processes.map { |p| format("%12s", p.current_state) }
    end
    
    def self.preempt_running_process
      if (preempted = running_process)
        preempted.state = ProcessState::Ready
        raise "More than one running process" if !running_process.nil?
        return preempted
      end
      nil
    end
    
    def self.run(process)
      process.start_run
    end
    
    def self.running_size
      ProcessTable.processes.select { |p| p.running? }.size
    end

    attr_accessor :processes
    def initialize(processes = [])
      @processes = processes
    end

  end
end