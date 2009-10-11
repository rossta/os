module Scheduling
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

    attr_accessor :processes
    def initialize(processes = [])
      @processes = processes
    end

  end
end