class Manager
  attr_reader :tasks, :cycle
  attr_writer :granted
  def initialize(tasks)
    @tasks      = tasks
    @cycle = 0
  end
  
  def safe?
    terminated?
  end
  
  def terminated?
    tasks.each { |t| t.terminate_if_processed }
    tasks.all? { |t| t.terminated? }
  end
  
  def cycle_clock
    Clock.cycle unless terminated?
  end
  
  def errors
    @errors ||= []
  end
  
  def available_tasks
    tasks.select { |t| t.processable? }
  end

  def completed_tasks
    tasks.select { |t| t.completed? }
  end
  
  def name
    self.class.name.upcase
  end
  
  protected

  def quick_display
    tasks.each do |task|
      Logger.info task.report
    end
  end
  
  
end