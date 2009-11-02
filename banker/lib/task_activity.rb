module TaskActivity

  ACTIVITIES = [
    INITIATE  = "initiate",
    REQUEST   = "request",
    RELEASE   = "release",
    COMPUTE   = "compute",
    TERMINATE = "terminate"
  ]

  class Base
    attr_accessor :processed
    def initialize(value_1 = nil, value_2 = nil)
      @value_1 = value_1
      @value_2 = value_2
      @processed = false
    end

    def name
      self.class.name.downcase.gsub(/(\w+)::/, "")
    end

    def process(task, resources)
      @processed = true
      self
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
    def process
      super(nil, nil)
    end
  end

  class Request < Base
    def resource_type
      @value_1
    end
    def units
      @value_2
    end
    def process(task, resources)
      resource = resources.detect { |r| resource_type == r.resource_type }
      if units <= resource.units
        task.allocate resource.resource_type, resource.request(units)
        super
      end
      self
    end
  end

  class Release < Base
    def resource_type
      @value_1
    end
    def units
      @value_2
    end
    def process(task, resources)
      resource = resources.detect { |r| resource_type == r.resource_type }
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