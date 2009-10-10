module Scheduling
  class Report
    INDENT = "    "
    attr_reader :os, :parser
    def initialize(os, parser, detailed = false)
      @os = os
      @parser = parser
      @detailed = detailed
    end

    def report
      text = [original_input]
      text << "The (sorted) input is: " + parser.to_s
      text << "\n"
      text << os.details.join("\n") + "\n" if detailed?
      text << processes_summary
      text << os_summary
      text.join("\n")
    end
    
    def to_s
      report
    end

    def original_input
      "The original input was: #{@parser.to_s}"
    end

    def processes_summary
      text = []
      os.processes.each_with_index do |p, i|
        process_text = ["Process #{i}:"]
        process_text << ProcessReport.new(p).report(INDENT)
        text << process_text.join("\n") + "\n"
      end
      text.join("\n")
    end

    def os_summary
      "Summary Data:\n" + OSReport.new(os).report(INDENT)
    end
    
    def detailed?
      !@detailed.nil?
    end

  end

  class OSReport
    def initialize(os)
      @os = os
    end

    def report(indent = "")
      text = []
      text << "Finishing time: #{@os.finishing_time}"
      text << "CPU Utilization: #{num_format @os.cpu_utilization}"
      text << "I/O Utilization: #{num_format @os.io_utilization}"
      text << "Throughput: #{num_format @os.throughput} processes per hundred cycles"
      text << "Average turnaround time: #{num_format @os.turnaround_time}"
      text << "Average waiting time: #{num_format @os.wait_time}"
      indent + text.join("\n" + indent)
    end
    
    protected
    
    def num_format(f)
      format("%f", f)
    end
  end

  class ProcessReport
    def initialize(process)
      @process = process
    end

    def report(indent = "")
      text = []
      text << "(A,B,C,IO) = #{process_params}"
      text << "Finishing time: #{@process.finishing_time}"
      text << "Turnaround time: #{@process.turnaround_time}"
      text << "I/O time: #{@process.io_time}"
      text << "Waiting time: #{@process.wait_time}"
      indent + text.join("\n" + indent)
    end

    protected

    def process_params
      text = "(#{@process.arrival_time},#{@process.max_cpu},#{@process.cpu_time},#{@process.max_io})"
    end

  end
end