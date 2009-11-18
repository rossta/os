module Paging
  class Report
    attr_reader :simulator
  
    def initialize(simulator)
      @simulator = simulator
    end
  
    def base_report
      text = []
      text << "The machine size is #{@simulator.machine_size}."
      text << "The page size is #{@simulator.page_size}."
      text << "The process size is #{@simulator.process_size}."
      text << "The job mix number is #{@simulator.job_mix_number}."
      text << "The number of references per process is #{@simulator.reference_rate}."
      text << "The replacement algorithm is #{@simulator.replacement_algorithm}."
      text << "The level of debugging output is #{@simulator.debug_level}"
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