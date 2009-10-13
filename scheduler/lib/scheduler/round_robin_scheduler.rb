module Scheduling
  class RoundRobinScheduler < Scheduler
    attr_accessor :cycle

    QUANTUM = 2

    def initialize
      @cycle = 0
    end
  
    def schedule_processes
      ProcessTable::ready_processes.each { |p| schedule(p) }
    end

    def schedule(process)
      return unless process.ready?
      queue << process if !queue.include?(process)
    end
  
    def before_next_process
      if self.cycle == QUANTUM || switch?
        self.cycle = 0
        queue << ProcessTable.preempt
        queue.compact!
      end
      self.cycle += 1
    end

    def switch?
      running_process.nil?
    end

  end
end
