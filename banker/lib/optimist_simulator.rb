class OptimistSimulator
  
  def algorithm
    @algorithm ||= Optimist.new(tasks, processes)
  end
end