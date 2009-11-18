module Paging
  class Simulator
    
    attr_reader :machine_size, :page_size, :process_size, :job_mix, :reference_rate, :replacement_algorithm, :debug_level
    attr_accessor :word
    
    def initialize(arguments)
      # M, the machine size in words. 
      # P, the page size in words. 
      # S, the size of a processes, i.e., the references are to virtual addresses 0..S-1. 
      # J, the ‘‘job mix’’, which determines A, B, and C, as described below. 
      # N, the number of references for each process. 
      # R, the replacement algorithm, LIFO, RANDOM, or LRU.
      
      @machine_size = arguments.shift.to_i
      @page_size    = arguments.shift.to_i
      @process_size = arguments.shift.to_i
      @job_mix      = Paging::JobMix.create(arguments.shift.to_i)
      @reference_rate = arguments.shift.to_i
      @replacement_algorithm = arguments.shift.downcase
      @debug_level  = arguments.shift.to_i || 0
      
      @word = 111
      initialize_processes
      RandomNumberGenerator.clear!
    end
    
    def run
      Clock.start
      while !terminated? do
        # select process
        # calculate word reference using random quotient
        # determine fault/hit and page frame
        cycle_clock
      end
    end
    
    def page_frames
      @page_frames ||= PageFrameTable.new(self.machine_size/self.page_size)
    end
    
    def word_reference(&block)
      @word = block.call(@word)
    end
    
    def terminated?
      ProcessTable.terminated?
    end
    
    def job_mix_number
      self.job_mix.number
    end
    
    protected
    
    def cycle_clock
      Clock.cycle       unless terminated?
    end
    
    def initialize_processes
      processes = Array.new(self.job_mix.size) { |i| Process.new(i, self.process_size, self.reference_rate) }
      ProcessTable.load_processes(processes)
    end
  end
end