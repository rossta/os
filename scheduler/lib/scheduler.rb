class Scheduler
  attr_accessor :queue

  def queue
    @queue ||= []
  end

  def run_next_process
    run_cycle
    return unless switch?
    return unless ready_process = queue.shift
    ready_process.start_run
  end

  def running_process
    Scheduling::ProcessTable.running_process
  end
  
  def run_cycle
    # record scheduler cycle if necessary
  end

end