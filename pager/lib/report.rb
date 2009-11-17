module Paging
  class Report
    attr_reader :pager
  
    def initialize(pager)
      @pager = pager
    end
  
    def base_report
      text = []
      text << "The machine size is #{@pager.machine_size}."
      text << "The page size is #{@pager.page_size}."
      text << "The process size is #{@pager.process_size}."
      text << "The job mix number is #{@pager.job_mix}."
      text << "The number of references per process is #{@pager.reference_rate}."
      text << "The replacement algorithm is #{@pager.replacement_algorithm}."
      text << "The level of debugging output is #{@pager.debug_level}"
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