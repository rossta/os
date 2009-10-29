class Banker
  attr_reader :tasks, :resources
  def initialize(tasks, resources)
    @tasks      = tasks
    @resources  = resources
  end
  
  def safe?
    tasks.all? { |t| t.terminated? }
  end
  
end