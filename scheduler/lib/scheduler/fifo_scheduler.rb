module Scheduling
  class FifoScheduler < Scheduler

    def schedule_processes
      ProcessTable.ready_processes.each { |p| schedule(p) }
    end

  end
end
