class OptimistSimulator
  
  def manager
    @manager ||= Optimist.new(tasks, processes)
  end

end