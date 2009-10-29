class Task
  def initialize
  end
  
  def add_activity(activity)
    activities << activity
  end
  
  def activities
    @activities ||= []
  end
end