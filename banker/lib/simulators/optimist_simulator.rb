class OptimistSimulator < Simulator

  def manager
    @manager ||= Optimist.new(tasks)
  end

end