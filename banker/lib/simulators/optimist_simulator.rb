class OptimistSimulator < Simulator
  attr_reader :manager, :tasks, :resources
  
  def manager
    @manager ||= Optimist.new(tasks)
  end

end