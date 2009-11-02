class Optimist < Manager

  def simulate
    while !terminated?
      current_activities = []
      tasks_to_process.each do |task|
        puts task.status
        strategy = management_strategy_for(task)
        current_activities << strategy.process
      end
      
      if deadlocked?(current_activities)
        first_task = tasks_to_process.first
        first_task.abort!
        first_task.allocation.each do |type, units|
          if (resource = resources.detect { |r| type == r.resource_type })
            resource.replenish(units)
          end
        end
      end
      
      cycle_clock
    end
    quick_display
  end
  
  def tasks_to_process
    tasks.select { |t| t.processable? }
  end
  
  def deadlocked?(current_activities)
    current_activities.compact.all? { |a| !a.processed? }
  end
  
  protected
  
  def management_strategy_for(task)
    ManagementStrategy::Fifo.new(task, resources)
  end
  
  def quick_display
    tasks.each do |task|
      puts task.report
    end
  end
end