module Paging
  class Page
    attr_reader :process
    attr_accessor :number, :load_time, :evict_time, :residency, :evictions
    def initialize(number, process)
      @number   = number
      @process  = process
      @residency = 0
      @evictions = 0
    end

    def load!
      @load_time  = Clock.time
      @evict_time = nil
    end

    def evict!
      @evict_time = Clock.time
      @residency += (@evict_time - @load_time)
      @evictions += 1
      @load_time  = nil
    end

    def size
      process.page_size
    end

  end
end