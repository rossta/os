class Optimist < Manager

  def simulate
    while !terminated?
      current_activities = tasks.select { |t| t.processable? }.map { |t| t.next_activity }
      current_activities.each do |activity|
        puts activity.task.status
        activity.process
      end
      
      if current_activities.all? { |a| !a.processed? }
        while current_activities.all? { |a| !a.processable? }
          activity = current_activities.shift
          activity.task.abort!
          ResourceTable.reallocate!
        end
      end
      tasks.each { |t| t.total_time += 1 }
      cycle_clock
    end
    quick_display
  end
  
  def completed_tasks
    tasks.select { |t| t.completed? }
  end
  
  protected
  
  # def management_strategy_for(task)
  #   ManagementStrategy::Fifo.new(task)
  # end
  # 
  def quick_display
    tasks.each do |task|
      puts task.report
    end
  end
end