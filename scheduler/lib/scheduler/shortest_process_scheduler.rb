module Scheduling
  class ShortestProcessScheduler < Scheduler
    
    def schedule_processes
      ProcessTable.ready_processes.each { |p| schedule(p) }
    end
    
    protected
    
    def next_process
      self.queue = queue.sort_by { |p| p.remaining_time }
      self.queue.shift
    end
  end
end