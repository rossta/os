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

    def self.sum(sym)
      processes.map { |p| p.send(sym) }.inject {|sum, n| sum + n }
    end

    def self.size
      processes.size
    end

    def self.terminated?
      processes.all? { |p| p.terminated? }
    end

    def self.ready_processes
      processes.select { |p| p.ready? }
    end
    
    def self.rotate(process)
      processes[process.number.modulo size]
    end

    attr_accessor :processes
    def initialize(processes = [])
      @processes = processes
    end

  end
end