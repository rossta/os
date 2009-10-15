module Scheduling
  class ShortestRemainingScheduler < Scheduler
    
    def preempt?
      return false if running_process.nil?
      running_process.remaining_time > shortest_remaining_time_on_queue
    end
    
    def schedule_ready_processes
      ProcessTable::ready_processes.each { |p| add_to_queue(p) }
      preempt! if preempt?
    end
    
    def choose_next
      self.queue = queue_sorted_by_remaining_time
      self.queue.shift
    end
    
    def queue_sorted_by_remaining_time
      self.queue.sort_by { |p| p.remaining_time }
    end
    
    def shortest_remaining_time_on_queue
      return running_process.remaining_time if queue.empty?
      queue_sorted_by_remaining_time.first.remaining_time
    end
  end
end