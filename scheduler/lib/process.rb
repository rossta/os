module Scheduling

  class Process
    attr_reader :arrival_time, :cpu_burst, :cpu_time, :io_burst
    def initialize(a, b, c, io)
      @arrival_time = a
      @cpu_burst = b
      @cpu_time = c
      @io_burst = io
    end
    
    def to_s
      text = "(#{arrival_time} #{cpu_burst} #{cpu_time} #{io_burst})"
    end
  end

end