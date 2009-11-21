module Paging
  class Process
    attr_reader :index, :size, :page_size, :reference_total, :pages
    attr_accessor :references, :faults
    def initialize(size, page_size, reference_total, index = 0)
      @index = index
      @size  = size
      @page_size = page_size
      @reference_total = reference_total
      @references = 0
      @faults = 0
      
      @pages = Array.new(@size/@page_size) { |i| Page.new(i, self) }
    end
    
    def page_reference(word)
      self.references += 1
      raise "Error: reference total exceeded" if self.references > self.reference_total
      pages.detect { |p| p.number == (word / page_size) }
    end
    
    def terminated?
      self.references >= self.reference_total
    end
    
    def number
      self.index + 1
    end
    
    def increment_faults
      self.faults += 1
    end
    
    def average_residency
      total_residency = self.pages.inject(0) { |sum, p| sum + p.residency }
      total_evictions = self.pages.inject(0) { |sum, p| sum + p.evictions }
      total_residency.to_f / total_evictions.to_f
    end
    
  end
end
