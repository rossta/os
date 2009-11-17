module Paging
  class Simulator
    attr_reader :machine_size, :page_size, :process_size, :job_mix, :reference_rate, :replacement_algorithm
    
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
      @job_mix      = arguments.shift.to_i
      @reference_rate = arguments.shift.to_i
      @replacement_algorithm = arguments.shift.downcase
    end
  end
end