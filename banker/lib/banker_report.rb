class BankerReport
  attr_reader :optimist, :banker
  def initialize(optimist, banker)
    @optimist = optimist
    @banker = banker
  end
  
  def to_s
    text = [header]
    text << optimist_report.to_s
    text.join("\n")
  end
  
  def header
    header = ""
    header += format("%-32s", "FIFO")
    # header += "BANKER"
  end
  
  def optimist_report
    @optimist_report ||= OptimistReport.new(optimist)
  end
  
  class OptimistReport
    attr_reader :manager
    def initialize(manager)
      @manager = manager
    end
    
    def to_s
      text = []
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
      manager_text << format("%4s\%", (overall_wait_time * 100) / overall_total_time)
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