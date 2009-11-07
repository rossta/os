class BankerSimulator < Simulator
  
  def manager
    @manager ||= Banker.new(tasks)
  end
  
end