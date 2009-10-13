module Scheduling
  class Scheduler
    attr_accessor :queue

    def queue
      @queue ||= []
    end

    def run_next_process
      return unless switch?
      return unless (ready_process = queue.shift)
      ProcessTable.run(ready_process)
    end
    
    def schedule(process)
      return unless process.ready?
      queue << process if !queue.include?(process)
    end

    def running_process
      ProcessTable.running_process
    end

    def switch?
      running_process.nil?
    end
  
  end
end
