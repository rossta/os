class Banker < Manager
  
  def simulate
    previously_blocked = []
    validate_safe_tasks
    
    while !terminated?
      Logger.info "cycle #{Clock.time} start"
      Logger.info  "#{ResourceTable.status}"
      # require "ruby-debug"; debugger
      
      current   = available_tasks.map { |t| t.next_activity }.sort_by { |a| a.task_number }
      requests  = current.select { |a| a.name == TaskActivity::REQUEST }
      available = current - previously_blocked
      
      Logger.info "current:            #{current.map{|a|a.task_number}.join(", ")}"
      Logger.info "available:          #{available.map{|a|a.task_number}.join(", ")}"
      Logger.info "previously_blocked: #{previously_blocked.map{|a|a.task_number}.join(", ")}"
      
      previously_blocked.each do |activity|
        if activity.greedy?
          activity.task.abort!
        elsif activity.safe?
          activity.process
        else
          activity.task.wait
        end
        Logger.info  "#{activity.task.status} #{activity.status}: #{ResourceTable.status}"
      end
      previously_blocked = previously_blocked.select { |a| !a.processed? }
      
      available.each do |activity|
        if activity.greedy?
          activity.task.abort!
        elsif activity.safe?
          activity.process
        else
          previously_blocked << activity unless previously_blocked.include? activity
          activity.task.wait
        end
        Logger.info  "#{activity.task.status} #{activity.status}: #{ResourceTable.status}"
      end
      
      ResourceTable.reallocate!
      Logger.info "cycle #{Clock.time} end"
      available_tasks.each { |t| t.total_time += 1 }
      cycle_clock
      Logger.info ""
    end
    quick_display
    
  end
  
  protected
  
  def validate_safe_tasks
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
  end
end