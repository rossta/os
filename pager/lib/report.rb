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
    
    def debug_report
      return nil unless Logger.debug?
      Logger.recorder.join("\n")
    end
  
    def process_report
      text = []
      ProcessTable.processes.each_with_index do |process, i|
        process_text = "Process #{i + 1} had #{process.faults} faults"
        if process.total_evictions > 0
          process_text += " and #{process.average_residency} average residency."
        else
          process_text += ".\n\t"
          process_text += "With no evictions, the average residence is undefined."
        end
        text << process_text
      end
      summary_text = "\nThe total number of faults is #{fault_sum}"
      if eviction_sum > 0
        summary_text += " and the overall average residency is #{overall_avg_residency}."
      else
        summary_text += ".\n\t"
        summary_text += "With no evictions, the overall average residence is undefined."
      end
      text << summary_text
      text.join("\n")
    end
    
    def to_s
      [base_report, debug_report, process_report].compact.join("\n\n")
    end
    
    protected
    
    def fault_sum
      ProcessTable.processes.inject(0) { |sum, p| sum + p.faults }
    end
    
    def eviction_sum
      ProcessTable.processes.inject(0) { |sum, p| sum + p.total_evictions }
    end
    
    def overall_avg_residency
      ProcessTable.processes.map { |p| p.average_residency }.inject(0) { |sum, val| sum + val } / ProcessTable.size
    end
  end
end