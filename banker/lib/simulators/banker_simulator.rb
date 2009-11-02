class BankerSimulator < Simulator
  
  def initialize(tasks, resources)
    @manager = Banker.new(tasks, resources)
  end
  
end