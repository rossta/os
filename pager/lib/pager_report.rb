module Paging
  class PagerReport
    attr_reader :pager
  
    def initialize(pager)
      @pager = pager
    end
  
    def base_report
      text = []
      text << "The machine size is 20."
      text << "The page size is 10."
      text << "The process size is 10."
      text << "The job mix number is 2."
      text << "The number of references per process is 10."
      text << "The replacement algorithm is random."
      text << "The level of debugging output is 0"
      text.join("\n")
    end
  
    def process_report
      text = []
      ProcessTable.processes.each_with_index do |process, i|
        text << "Process #{i + 1} had #{process.faults} faults and #{process.average_residency} average residency."
      end
      text << "\nThe total number of faults is #{fault_sum} and the overall average residency is #{overall_avg_residency}."
      text.join("\n")
    end
    
    protected
    
    def fault_sum
      ProcessTable.processes.inject(0) { |sum, p| sum + p.faults }
    end
    
    def overall_avg_residency
      ProcessTable.processes.map { |p| p.average_residency }.inject(0) { |sum, val| sum + val } / ProcessTable.size
    end
  end
end