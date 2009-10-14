module Scheduling
  class HighestPenaltyScheduler < Scheduler
    def preempt?
      false
    end
    
    def next_process
      high_r                = self.queue.map { |p| p.r_value }.max
      high_r_processes      = self.queue.find_all { |p| p.r_value == high_r }
      first_high_r_process  = high_r_processes.sort_by { |p| p.index }.first

      self.queue.delete(first_high_r_process)
    end
    
  end
end