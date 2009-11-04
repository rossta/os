module ManagementStrategy
  
  class Base
    attr_reader :task, :resources
    def initialize(task)
      @task = task
    end
  end
  
  class Fifo < Base
    def process
      return if task.terminated? || task.aborted?
      task.process_activity
    end
  end
end