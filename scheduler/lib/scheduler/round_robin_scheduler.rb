module Scheduling
  class RoundRobinScheduler < Scheduler
    attr_accessor :quantum

    QUANTUM = 2

    def initialize
      @quantum = 0
    end

    def schedule_processes
      preempt! if preempt?
      ProcessTable::ready_processes.each { |p| schedule(p) }
      self.quantum += 1
    end
    
    def preempt?
      self.quantum == QUANTUM || switch?
    end

    def preempt!
      self.quantum = 0
      ProcessTable.preempt
    end

  end
end
