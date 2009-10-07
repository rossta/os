class Scheduler
  attr_accessor :queue
  
  def initialize
    
  end
  
  def queue
    @queue ||= []
  end
  
  def next_ready_process
    raise "Subclass must implement"
  end

end