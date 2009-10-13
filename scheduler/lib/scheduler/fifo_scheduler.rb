module Scheduling
  class FifoScheduler < Scheduler

    def schedule(process)
      return unless process.ready?
      queue << process if !queue.include?(process)
    end

    def switch?
      running_process.nil?
    end
  
    def schedule_processes
      ProcessTable.ready_processes.each { |p| schedule(p) }
    end

  end
end
