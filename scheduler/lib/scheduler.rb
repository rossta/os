module Scheduling
  class Scheduler
    attr_accessor :queue

    def queue
      @queue ||= []
    end

    def run_next_process
      return unless switch?
      return unless (ready_process = choose_next)
      ProcessTable.run(ready_process)
    end
    
    def switch?
      running_process.nil?
    end
    
    def schedule(process)
      return unless process.ready?
      queue << process if !queue.include?(process)
    end
    
    def schedule_ready_processes
      preempt! if preempt?
      ProcessTable::ready_processes.each { |p| schedule(p) }
    end
    
    def preempt!
      ProcessTable.preempt_running_process
    end

    def choose_next
      queue.shift
    end

    protected
    
    def running_process
      ProcessTable.running_process
    end

  end
end
