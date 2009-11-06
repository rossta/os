module TaskActivity

  ACTIVITIES = [
    INITIATE  = "initiate",
    REQUEST   = "request",
    RELEASE   = "release",
    COMPUTE   = "compute",
    TERMINATE = "terminate"
  ]

  class Base
    attr_accessor :task, :processed, :value_2
    def initialize(task, value_1 = nil, value_2 = nil)
      @task    = task
      @value_1 = value_1
      @value_2 = value_2
      @processed = false
    end
    
    def task_number
      task.number
    end

    def name
      self.class.name.downcase.gsub(/(\w+)::/, "")
    end

    def process
      @processed  = true
    end

    def processed?
      @processed
    end

    def blocked?
      false
    end
    
    def status
      "#{name} #{value_2}"
    end
    
  end

  class Initiate < Base
    def resource_type
      @value_1
    end

    def units
      @value_2
    end
  end

  class Terminate < Base
  end

  class Request < Base
    def resource_type
      @value_1
    end
    def units
      @value_2
    end
    def process
      if blocked?
        task.wait
        puts "Task #{task_number} wait"
        false
      else
        task.allocate resource_type, resource.request(units)
        super
      end
    end
    
    def blocked?
      units > resource.units
    end
    
    def resource
      @resource ||= ResourceTable.find(resource_type)
    end
  end

  class Release < Base
    def resource_type
      @value_1
    end
    def units
      @value_2
    end
    def process
      resource = ResourceTable.find(resource_type)
      ResourceTable.replenish task.release(resource.resource_type, units)
      super
    end
  end

  class Compute < Base
    attr_accessor :processed_cycles
    def initialize(task, value_1)
      super
      @processed_cycles = 0
    end
    def total_cycles
      @value_1
    end
    def process
      self.processed_cycles +=1
      if processed_cycles == total_cycles
        super
      else
        false
      end
    end
  end
end