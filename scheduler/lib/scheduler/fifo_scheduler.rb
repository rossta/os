module Scheduling
  class FifoScheduler < Scheduler
    
    def preempt?
      false
    end

  end
end
