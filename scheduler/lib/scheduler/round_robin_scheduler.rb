module Scheduling
  class RoundRobinScheduler < Scheduler
    attr_accessor :quantum

    QUANTUM = 2

    def initialize
      @quantum = 0
    end

    def schedule_ready_processes
      preempt! if preempt?
      ProcessTable::ready_processes.each { |p| add_to_queue(p) }
      self.quantum += 1
    end
    
    def preempt?
      self.quantum == QUANTUM || switch?
    end

    def preempt!
      self.quantum = 0
      super
    end

  end
end
