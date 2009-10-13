module Scheduling
  class Scheduler
    attr_accessor :queue

    def queue
      @queue ||= []
    end

    def run_next_process
      return unless switch?
      return unless (ready_process = next_process)
      ProcessTable.run(ready_process)
    end
    
    protected
    
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
    
    def next_process
      queue.shift
    end
  end
end
