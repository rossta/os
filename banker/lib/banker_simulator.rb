class BankerSimulator
  
  def algorithm
    @algorithm ||= Banker.new(tasks, processes)
  end
  
end