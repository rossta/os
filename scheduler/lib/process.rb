module Scheduling
  class Process
    attr_reader   :arrival_time,   :max_cpu,  :cpu_time,  :max_io, :finishing_time
    attr_accessor :io_time,  :wait_time, :state, :cpu_burst, :io_burst, :remaining_time

    def initialize(a, b, c, io)
      @arrival_time   = a
      @max_cpu        = b
      @cpu_time       = c
      @max_io         = io
      @wait_time      = 0
      @io_time        = 0
      @remaining_time = cpu_time
      @state          = Scheduling::ProcessState::Unstarted
    end
    
    def cycle
      @state = @state.cycle(self)
    end
    
    def to_s
      text = "( #{arrival_time} #{max_cpu} #{cpu_time} #{max_io} )"
    end
    
    def turnaround_time
      finishing_time - arrival_time
    end
    
    def finishing_time
      arrival_time + cpu_time + wait_time + io_time
    end
    
    def cpu_burst
      @cpu_burst ||= 0
    end
    
    def io_burst
      @io_burst ||= 0
    end
    
    def start_run
      self.cpu_burst = Scheduling::OS.random_os(self.max_cpu)
      @state = ProcessState::Running
    end
    
    def method_missing(sym, *args, &block)
      state_methods = [:ready?, :terminated?, :running?, :blocked?, :unstarted?]
      if state_methods.include?(sym)
        @state.to_sym == sym
      else
        raise NoMethodError, sym.to_s
      end
    end
    
  end

  module ProcessState
    class Unstarted
      def self.cycle(process)
        Ready
      end
      
      def self.to_sym
        :unstarted?
      end
    end
    
    class Ready #TODO 
      def self.cycle(process)
        if process.cpu_burst > 0
          Running.cycle(process)
        else
          process.wait_time += 1
          Ready
        end
      end

      def self.to_sym
        :ready?
      end
    end
    
    class Running
      def self.cycle(process)
        process.cpu_burst -= 1
        process.remaining_time -= 1
        if process.remaining_time == 0
          Terminated
        elsif process.cpu_burst   == 0
          Blocked
        else
          Running
        end
      end

      def self.to_sym
        :running?
      end

    end
    
    class Blocked
      def self.cycle(process)
        process.io_time   += 1
        process.io_burst  -= 1
        if process.io_burst == 0
          Ready
        else
          Blocked
        end
      end

      def self.to_sym
        :blocked?
      end

    end

    class Terminated
      def self.cycle(process)
        self
      end
      
      def self.to_sym
        :terminated?
      end

    end
  end

end