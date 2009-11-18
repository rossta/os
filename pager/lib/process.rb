module Paging
  class Process
    attr_reader :index, :size, :page_size, :reference_total
    attr_accessor :references
    def initialize(size, page_size, reference_total, index = 0)
      @index = index
      @size  = size
      @page_size = page_size
      @reference_total = reference_total
      @references = 0
    end
    
    def page_reference(word)
      @references += 1
      word / page_size
    end
    
    def terminated?
      self.references == self.reference_total
    end
    
    def number
      self.index + 1
    end
    
  end
end
