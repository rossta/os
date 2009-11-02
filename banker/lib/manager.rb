class Manager
  attr_reader :tasks, :resources, :cycle
  def initialize(tasks, resources)
    @tasks      = tasks
    @resources  = resources
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