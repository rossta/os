module Scheduling
  class Report
    INDENT = "\t"
    attr_reader :os, :parser
    def initialize(os, parser)
      @os = os
      @parser = parser
    end

    def report
      text = [parser.to_s]
      text << "\n"
      text << details + "\n" if os.detailed?
      text << processes_summary
      text << os_summary
      text.join("\n")
    end
    alias_method :to_s, :report

    def processes_summary
      text = []
      ProcessTable.processes.each_with_index do |p, i|
        process_text = ["Process #{i}:"]
        process_text << ProcessReport.new(p).report(INDENT)
        text << process_text.join("\n") + "\n"
      end
      text.join("\n")
    end

    def os_summary
      "Summary Data:\n" + OSReport.new.report(INDENT)
    end
    
    def details
      os.details.join("\n")
    end
    
    def states
      os.states
    end

  end

  class OSReport
    def report(indent = "")
      text = []
      text << "Finishing time: #{Clock.time}"
      text << "CPU Utilization: #{num_format cpu_utilization}"
      text << "I/O Utilization: #{num_format io_utilization}"
      text << "Throughput: #{num_format throughput} processes per hundred cycles"
      text << "Average turnaround time: #{num_format turnaround_time}"
      text << "Average waiting time: #{num_format wait_time}"
      indent + text.join("\n" + indent)
    end
    
    def cpu_utilization
      ProcessTable.sum(:cpu_time).to_f / Clock.time
    end

    def io_utilization
      Clock.io_time.to_f / Clock.time
    end

    def throughput
      ProcessTable.size * 100.0 / Clock.time.to_f
    end

    def turnaround_time
      ProcessTable.sum(:turnaround_time).to_f / ProcessTable.size
    end

    def wait_time
      ProcessTable.sum(:wait_time).to_f / ProcessTable.size
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