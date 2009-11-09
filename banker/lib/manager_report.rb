class ManagerReport
  attr_reader :manager
  def initialize(manager)
    @manager = manager
  end
  
  def to_s
    text = [header]
    text << manager_report.to_s
    text.join("\n")
  end
  
  def header
    header = ""
    header += format("%-32s", "FIFO")
  end
  
  def manager_report
    @manager_report ||= ManagerReport.new(manager)
  end
  
  class ManagerReport
    attr_reader :manager
    def initialize(manager)
      @manager = manager
    end
    
    def to_s
      text = []
      text << manager.errors if manager.errors.any?
      text << manager.name
      manager.tasks.each do |task|
        task_text = [format("%-9s",   "Task #{task.number}")]
        if task.aborted?
          task_text << format("%10s",   "aborted")
          task_text << format("%37s",   "")
        else
          task_text << format("%4s",    task.total_time)
          task_text << format("%4s",    task.wait_time)
          task_text << format("%4s\%",  task.percent_waiting)
          task_text << format("%34s",   "")
        end
        text << task_text.join
      end
      manager_text = [format("%-9s",  "total")]
      manager_text << format("%4s",   overall_total_time)
      manager_text << format("%4s",   overall_wait_time)
      manager_text << format("%4s\%", (overall_wait_time.to_f * 100).ceil / overall_total_time)
      manager_text << format("%s",  "") #34
      text << manager_text.join
      text.join("\n")
    end
    
    def overall_total_time
      manager.completed_tasks.inject(0) { |sum, t| sum + t.total_time }
    end
    
    def overall_wait_time
      manager.completed_tasks.inject(0) { |sum, t| sum + t.wait_time }
    end
  end
end
