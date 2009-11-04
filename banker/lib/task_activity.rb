module TaskActivity

  ACTIVITIES = [
    INITIATE  = "initiate",
    REQUEST   = "request",
    RELEASE   = "release",
    COMPUTE   = "compute",
    TERMINATE = "terminate"
  ]

  class Base
    attr_accessor :task, :processed
    def initialize(task, value_1 = nil, value_2 = nil)
      @task    = task
      @value_1 = value_1
      @value_2 = value_2
      @processed = false
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
      if processable?
        task.allocate resource.resource_type, resource.request(units)
        super
      else
        task.wait
        false
      end
    end
    def processable?
      units <= resource.units
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
      resource.replenish task.release(resource.resource_type, units)
      super
    end
  end

  class Compute < Base
    def number_cycles
      @value_1
    end
  end
end