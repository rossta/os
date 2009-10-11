module Scheduling
  class Clock
    def self.start
      @@instance = new
    end
    
    def self.instance
      @@instance ||= new
    end
    
    def self.method_missing(sym, *args, &block)
      if (instance.methods - instance.class.methods).map { |m| m.to_sym }.include?(sym)
        instance.send(sym)
      else
        raise NoMethodError, sym.to_s
      end
    end
    
    def initialize
      @cycles = 0
      @io_cycles = 0
    end
    
    def cycle
      @cycles += 1
    end
    
    def cycle_io
      @io_cycles += 1
    end
    
    def time
      @cycles
    end
    
    def io_time
      @io_cycles
    end
    
  end
end