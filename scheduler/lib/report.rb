module Scheduling
  class Report
    INDENT = "    "
    attr_reader :os, :parser
    def initialize(os, parser)
      @os = os
      @parser = parser
    end
    
    def report
      text = [original_input]
      text << "The (sorted) input is: " + parser.to_s
      text << "\n"
      text << processes_summary
      text.join("\n")
    end
    
    def original_input
      "The original input was: #{@parser.to_s}"
    end
    
    def processes_summary
      text = []
      os.processes.each_with_index do |p, i|
        process_text = ["Process #{i}:"]
        process_text << ProcessReport.new(p).report(INDENT)
        text << process_text.join("\n")
      end
      text.join("\n")
    end
    
  end
  
  class ProcessReport
    def initialize(process)
      @process = process
    end
    
    def report(indent = "")
      text = ["#{indent}(A,B,C,IO) = #{process_params}"]
      text << "#{indent}Finishing time: #{@process.finishing_time}"
      text << "#{indent}Turnaround time: #{@process.turnaround_time}"
      text << "#{indent}I/O time: #{@process.io_time}"
      text << "#{indent}Waiting time: #{@process.wait_time}"
      text.join("\n")
    end
    
    protected
    
    def process_params
      text = "(#{@process.arrival_time},#{@process.max_cpu},#{@process.cpu_time},#{@process.max_io})"
    end
    
  end
end