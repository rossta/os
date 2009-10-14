module Scheduling
  class Process
    attr_reader   :arrival_time,   :max_cpu,  :cpu_time,  :max_io, :finishing_time, :index
    attr_accessor :io_time,  :wait_time, :state, :cpu_burst, :io_burst, :remaining_time

    def initialize(a, b, c, io, index = nil)
      @arrival_time   = a
      @max_cpu        = b
      @cpu_time       = c
      @max_io         = io
      @wait_time      = 0
      @io_time        = 0
      @index          = index
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
      self.cpu_burst = Scheduling::OS.random_os(self.max_cpu, self.state) if self.cpu_burst == 0
      self.state = ProcessState::Running
    end
    
    def current_state
      @state.current(self)
    end
    
    def r_value
      t = [1, (cpu_time - remaining_time)].max
      (Clock.time - arrival_time).to_f / t
    end

    def <=>(other)
      return -1 if self.arrival_time < other.arrival_time
      return 1  if self.arrival_time > other.arrival_time
      return -1 if self.index < other.index
      return 1  if self.index > other.index
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

      def self.current(process)
        "#{to_s} 0"
      end
      
      def self.to_s
        "unstarted"
      end
      
    end
    
    class Ready #TODO 
      def self.cycle(process)
        process.wait_time += 1
        Ready
      end

      def self.to_sym
        :ready?
      end
      
      def self.current(process)
        "#{to_s} 0"
      end
      
      def self.to_s
        "ready"
      end
    end
    
    class Running
      def self.cycle(process)
        process.cpu_burst -= 1
        process.remaining_time -= 1
        if process.remaining_time == 0
          Terminated
        elsif process.cpu_burst   == 0
          process.io_burst = Scheduling::OS.random_os(process.max_io, process.state)
          Blocked
        else
          Running
        end
      end

      def self.to_sym
        :running?
      end
      
      def self.current(process)
        "#{to_s} #{process.cpu_burst}"
      end
      
      def self.to_s
        "running"
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

      def self.current(process)
        "#{to_s} #{process.io_burst}"
      end
      
      def self.to_s
        "blocked"
      end
      
    end

    class Terminated
      def self.cycle(process)
        self
      end
      
      def self.to_sym
        :terminated?
      end
      
      def self.current(process)
        "#{to_s} 0"
      end
      
      def self.to_s
        "terminated"
      end
    end
  end

end