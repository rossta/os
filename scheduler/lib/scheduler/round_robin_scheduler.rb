class RoundRobinScheduler < Scheduler
  attr_accessor :cycle

  QUANTUM = 2

  def initialize
    @cycle = 0
  end

  def schedule(process)
    return unless process.ready?
    queue << process if !queue.include?(process)
  end
  
  def switch?
    running_process.nil? || @cycle == 0
  end

  def run_cycle
    if @cycle == 0
      @cycle = QUANTUM
    else
      @cycle -= 1
    end
  end
end