class Optimist < Manager

  def simulate
    previously_blocked = []

    while !terminated?
      Logger.info "cycle #{Clock.time} start"
      Logger.info  "#{ResourceTable.status}"
      current = available_tasks.map { |t| t.next_activity }
      
      if current.all? { |a| a.blocked? }
        previously_blocked = current
        previously_blocked.each { |a| a.process }
        Logger.info "Blocked"
        begin
          if (activity = previously_blocked.shift)
            Logger.info "Aborting task #{activity.task_number}"
            activity.task.abort!
            ResourceTable.reallocate!
            Logger.info "Releasing #{activity.task.allocation.values.join(", ")} units: #{ResourceTable.status}"
          end
        end while current.all? { |a| a.blocked? }
      else
        available = current - previously_blocked
        Logger.info "current:            #{current.map{|a|a.task_number}.join(", ")}"
        Logger.info "available:          #{available.map{|a|a.task_number}.join(", ")}"
        Logger.info "previously blocked: #{previously_blocked.map{|a|a.task_number}.join(", ")}"
        previously_blocked.each do |activity|
          activity.process
          Logger.info  "#{activity.task.status} #{activity.status} (previously blocked): #{ResourceTable.status}"
        end
        previously_blocked = previously_blocked.select { |a| !a.processed? }

        available.each do |activity|
          activity.process
          Logger.info "#{activity.task.status} #{activity.status}: #{ResourceTable.status}"
        end
        previously_blocked += available.select { |a| !a.processed? }
        ResourceTable.reallocate!
      end

      Logger.info "cycle #{Clock.time} end"
      available_tasks.each { |t| t.total_time += 1 }
      cycle_clock
      Logger.info ""
    end
    quick_display
  end

end