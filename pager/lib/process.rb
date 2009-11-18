module Paging
  class Process
    attr_reader :index, :size, :reference_total
    attr_accessor :references
    def initialize(index, size, reference_total)
      @index = index
      @size  = size
      @reference_total = reference_total
      @references = 0
    end
    
    def reference
      @references += 1
    end
    
    def terminated?
      self.references == self.reference_total
    end
    
  end
end