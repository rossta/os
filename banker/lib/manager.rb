class Manager
  attr_reader :tasks, :cycle
  attr_writer :granted
  def initialize(tasks)
    @tasks      = tasks
    @cycle = 0
  end
  
  def safe?
    terminated?
  end
  
  def terminated?
    tasks.each { |t| t.terminate_if_processed }
    tasks.all? { |t| t.terminated? }
  end
  
  def cycle_clock
    Clock.cycle unless terminated?
  end
  
end