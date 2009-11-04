class Simulator
  attr_reader :manager, :tasks, :resources
  
  def initialize(tasks, resources)
    @tasks = tasks
    ResourceTable.build(resources)
  end
  
  def simulate!
    Clock.start
    manager.simulate
  end

end