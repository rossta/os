class Optimist < Manager

  def simulate
    previously_blocked = []
    available_tasks.each do |task|
      task.initial_claim.each do |claim|
        claimed_units   = claim.units
        resource_units  = ResourceTable.find(claim.resource_type).units
        if claimed_units > resource_units
          task.abort!
          errors << "Banker aborts task #{task.number} before run begins: claim for resource #{claim.resource_type} (#{claimed_units}) exceeds number of units present (#{resource_units})"
          next
        end
      end
    end

    while !terminated?
      # require "ruby-debug"; debugger if Clock.time == 3
      
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