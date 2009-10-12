class FifoScheduler < Scheduler

  def schedule(process)
    return unless process.ready?
    queue << process if !queue.include?(process)
  end

  def switch?
    running_process.nil?
  end

end