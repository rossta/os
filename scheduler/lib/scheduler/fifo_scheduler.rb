class FifoScheduler < Scheduler


  def schedule(process)
    return unless process.ready?
    queue << process if !queue.include?(process)
  end
  
  def run_next_process
    return unless running = next_ready_process
    running.start_run
  end

  def next_ready_process
    queue.shift
  end
end