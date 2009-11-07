class Optimist < Manager

  def simulate
    previously_blocked = []

    while !terminated?
      puts "cycle #{Clock.time} start"
      puts  "#{ResourceTable.status}"
      current = available_tasks.map { |t| t.next_activity }
      
      if current.all? { |a| a.blocked? }
        previously_blocked = current
        previously_blocked.each { |a| a.process }
        puts "Blocked"
        begin
          if (activity = previously_blocked.shift)
            puts "Aborting task #{activity.task_number}"
            activity.task.abort!
            ResourceTable.reallocate!
            puts "Releasing #{activity.task.allocation.values.join(", ")} units: #{ResourceTable.status}"
          end
        end while current.all? { |a| a.blocked? }
      else
        available = current - previously_blocked
        puts "current:            #{current.map{|a|a.task_number}.join(", ")}"
        puts "available:          #{available.map{|a|a.task_number}.join(", ")}"
        puts "previously blocked: #{previously_blocked.map{|a|a.task_number}.join(", ")}"
        previously_blocked.each do |activity|
          activity.process
          puts  "#{activity.task.status} #{activity.status} (previously blocked): #{ResourceTable.status}"
        end
        previously_blocked = previously_blocked.select { |a| !a.processed? }

        available.each do |activity|
          activity.process
          puts "#{activity.task.status} #{activity.status}: #{ResourceTable.status}"
        end
        previously_blocked += available.select { |a| !a.processed? }
        ResourceTable.reallocate!
      end

      puts "cycle #{Clock.time} end"
      available_tasks.each { |t| t.total_time += 1 }
      cycle_clock
      puts ""
    end
    quick_display
  end

end