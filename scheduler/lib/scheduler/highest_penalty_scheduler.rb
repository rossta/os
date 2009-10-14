module Scheduling
  class HighestPenaltyScheduler < Scheduler
    def preempt?
      false
    end
    
    def next_process
      highest_r           = self.queue.map { |p| p.r_value }.max
      highest_r_processes = self.queue.find_all { |p| p.r_value == highest_r }
      self.queue.delete(highest_r_processes.first)
    end
    
  end
end