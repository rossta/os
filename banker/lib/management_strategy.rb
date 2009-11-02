module ManagementStrategy
  
  class Base
    attr_reader :task, :resources
    def initialize(task, resources)
      @task = task
      @resources = resources
    end
  end
  
  class Fifo < Base
    def process
      return if task.terminated? || task.aborted?
      task.process_activity(resources)
    end
  end
end