module Command
  
  COMMANDS = [
    INITIATE  = "initiate",
    REQUEST   = "request",
    RELEASE   = "release",
    COMPUTE   = "compute",
    TERMINATE = "terminate"
  ]
  
  class Base
    
  end
  
  class Initiate < Base
    def initialize(resource_type, initial_claim)
      
    end
    
    def name
      INITIATE
    end
  end
  
  class Terminate < Base
    def name
      TERMINATE
    end
  end
  
  class Request < Base
    def initialize(resource_type, number_requested)
      
    end
  end

  class Release < Base
    def initialize(resource_type, number_released)
      
    end
  end

  class Compute < Base
    def initialize(number_cycles)
      
    end
  end
end