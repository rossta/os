class Banker < Manager
  
  def simulate
    previously_blocked = []
    
    while !terminated?
      puts "cycle #{Clock.time} start"
      puts  "#{ResourceTable.status}"
      
      current   = available_tasks.map { |t| t.next_activity }
      requests  = current.select { |a| a.name == TaskActivity::REQUEST }
      other     = current - requests
      
      puts "current:      #{current.map{|a|a.task_number}.join(", ")}"
      puts "requests:     #{requests.map{|a|a.task_number}.join(", ")}"
      puts "other:        #{other.map{|a|a.task_number}.join(", ")}"
      
      requests.each do |activity|
        puts  "#{activity.task.status} #{activity.status}: #{ResourceTable.status}"
        if activity.task.safe?
          activity.process
        else
          activity.task.wait
        end
      end
      
      other.each do |activity|
        puts  "#{activity.task.status} #{activity.status}: #{ResourceTable.status}"
        activity.process
      end
      
      ResourceTable.reallocate!
      puts "cycle #{Clock.time} end"
      available_tasks.each { |t| t.total_time += 1 }
      cycle_clock
      puts ""
    end
    quick_display
    
  end
end