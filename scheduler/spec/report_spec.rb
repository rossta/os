require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::Report do
  
  describe "report" do
    it "should report original input" do
      parser = mock(ProcessParser, :to_s => "original_input")
      report = Scheduling::Report.new(mock(Scheduling::OS), parser)
      report.original_input.should == "The original input was: " + parser.to_s
    end
    
    it "should report sorted input"
    
    it "should report each process summary" do
      processes = []
      p0 = mock(Scheduling::Process, :report => "process 0 report")
      p1 = mock(Scheduling::Process, :report => "process 1 report")
      processes << p0
      processes << p1
      Scheduling::ProcessReport.should_receive(:new).with(p0).and_return(mock(Scheduling::ProcessReport, :report => "process 0 report"))
      Scheduling::ProcessReport.should_receive(:new).with(p1).and_return(mock(Scheduling::ProcessReport, :report => "process 1 report"))
      report = Scheduling::Report.new(mock(Scheduling::OS, :processes => processes), mock(ProcessParser))
      report.processes_summary.should == "Process 0:\nprocess 0 report\n\nProcess 1:\nprocess 1 report\n"
    end
    
    it "should report os summary" do
      Scheduling::OSReport.should_receive(:new).and_return(mock(Scheduling::OSReport, :report => "os report"))
      report = Scheduling::Report.new(mock(Scheduling::OS), mock(ProcessParser))
      report.os_summary.should == "Summary Data:\nos report"
    end
    
    describe "verbose" do
      it "should also report process state for each cycle"
      it "should also report remaining burst for each cycle"
    end
  end
  
end

describe "Scheduling::ProcessReport" do
  describe "report" do
    it "should print process report" do
      expected_output = "(A,B,C,IO) = (0,1,5,1)\n" +
                        "Finishing time: 9\n" +
                        "Turnaround time: 9\n" +
                        "I/O time: 4\n" +
                        "Waiting time: 0"
      process = mock(Scheduling::OS,
        :arrival_time    => 0,
        :max_cpu         => 1,
        :cpu_time        => 5,
        :max_io          => 1,
        :finishing_time  => 9,
        :turnaround_time => 9,
        :io_time         => 4,
        :wait_time       => 0
      )
      Scheduling::ProcessReport.new(process).report.should == expected_output
    end
  end
end

describe "Scheduling::OSReport" do
  describe "report" do
    it "should print process report" do
      expected_output = "Finishing time: 9\n" +
                        "CPU Utilization: 0.550000\n" +
                        "I/O Utilization: 0.440000\n" +
                        "Throughput: 11.110000 processes per hundred cycles\n" +
                        "Average turnaround time: 9.000000\n" +
                        "Average waiting time: 0.000000"

      process = mock(Scheduling::OS,
        :finishing_time   => 9,
        :cpu_utilization  => 0.55,
        :io_utilization   => 0.44,
        :throughput       => 11.11,
        :turnaround_time  => 9.0,
        :wait_time        => 0.0
      )
      Scheduling::OSReport.new(process).report.should == expected_output
    end
  end
end