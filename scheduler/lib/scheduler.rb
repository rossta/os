class Scheduler
  attr_accessor :queue

  def queue
    @queue ||= []
  end

  def run_next_process
    before_next_process
    return unless switch?
    return unless (ready_process = queue.shift)
    Scheduling::ProcessTable.run(ready_process)
  end

  def running_process
    Scheduling::ProcessTable.running_process
  end
  
  def before_next_process
    # record scheduler cycle if necessary
  end

end