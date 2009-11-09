class Simulator
  attr_reader :manager, :resources
  
  def initialize(manager, resources)
    @manager = manager
    ResourceTable.build(resources)
    ResourceTable.reset!
  end
  
  def simulate!
    Clock.start
    manager.simulate
  end

end