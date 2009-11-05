class Optimist < Manager

  def simulate
    previously_blocked = []
    while !terminated?
      puts "cycle #{Clock.time} start"
      
      available = available_tasks.map { |t| t.next_activity } - previously_blocked
      current   = previously_blocked + available
      
      if current.all? { |a| a.blocked? }
        while current.all? { |a| a.blocked? }
          if (activity = current.shift)
            activity.task.abort!
            previously_blocked.delete(activity)
            ResourceTable.reallocate!
          end
        end
      else
        previously_blocked.each do |activity|
          puts activity.task.status + "(previously blocked)"
          activity.process
          previously_blocked.delete(activity) if activity.processed?
        end

        available.each do |activity|
          puts activity.task.status
          activity.process
          previously_blocked << activity if activity.blocked?
        end
      end

      puts "cycle #{Clock.time} end"
      tasks.each { |t| t.total_time += 1 }
      cycle_clock
      puts ""
    end
    quick_display
  end

  def available_tasks
    tasks.select { |t| t.processable? }
  end

  def completed_tasks
    tasks.select { |t| t.completed? }
  end
  
  protected

  def quick_display
    tasks.each do |task|
      puts task.report
    end
  end
end