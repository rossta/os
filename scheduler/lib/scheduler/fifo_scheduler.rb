class FifoScheduler < Scheduler

  def next_ready_process
    queue.shift
  end

  def schedule(process)
    return unless process.ready?
    queue << process if !queue.include?(process)
  end

end