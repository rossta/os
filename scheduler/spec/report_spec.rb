require File.dirname(__FILE__) + '/spec_helper'

describe Scheduling::Report do
  
  describe "report" do
    
    it "should report each process summary" do
      p0 = mock(Scheduling::Process, :report => "process 0 report")
      p1 = mock(Scheduling::Process, :report => "process 1 report")
      Scheduling::ProcessTable.stub!(:processes).and_return([p0, p1])
      Scheduling::ProcessReport.should_receive(:new).with(p0).and_return(mock(Scheduling::ProcessReport, :report => "process 0 report"))
      Scheduling::ProcessReport.should_receive(:new).with(p1).and_return(mock(Scheduling::ProcessReport, :report => "process 1 report"))
      report = Scheduling::Report.new(mock(Scheduling::OS), mock(ProcessParser))
      report.processes_summary.should == "Process 0:\nprocess 0 report\n\nProcess 1:\nprocess 1 report\n"
    end
    
    it "should report os summary" do
      Scheduling::OSReport.should_receive(:new).and_return(mock(Scheduling::OSReport, :report => "os report"))
      report = Scheduling::Report.new(mock(Scheduling::OS), mock(ProcessParser))
      report.os_summary.should == "Summary Data:\nos report"
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
                        "CPU Utilization: 0.555556\n" +
                        "I/O Utilization: 0.444444\n" +
                        "Throughput: 11.111111 processes per hundred cycles\n" +
                        "Average turnaround time: 9.000000\n" +
                        "Average waiting time: 0.000000"
      Scheduling::ProcessTable.stub!(:sum).with(:cpu_time).and_return(5)
      Scheduling::ProcessTable.stub!(:sum).with(:turnaround_time).and_return(9)
      Scheduling::ProcessTable.stub!(:sum).with(:wait_time).and_return(0)
      Scheduling::ProcessTable.stub!(:size).and_return(1)
      Clock.stub!(:time).and_return(9)
      Clock.stub!(:io_time).and_return(4)
      Scheduling::OSReport.new.report.should == expected_output
    end
  end
  
  describe "cpu_utilization" do
    it "should return floating point total cpu time / finishing time" do
      Scheduling::ProcessTable.stub!(:sum).with(:cpu_time).and_return(8)
      Clock.stub!(:time).and_return(10)
      Scheduling::OSReport.new.cpu_utilization.should == 0.8
    end
  end

  describe "io_utilization" do
    it "should return floating point total io time / finishing time" do
      Clock.stub!(:io_time).and_return(8)
      Clock.stub!(:time).and_return(10)
      Scheduling::OSReport.new.io_utilization.should == 0.8
    end
  end

  describe "throughput" do
    it "should return number of processes * 100 / finishing time" do
      Scheduling::ProcessTable.stub!(:size).and_return(2)
      Clock.stub!(:time).and_return(10)
      Scheduling::OSReport.new.throughput.should == 20.0
    end
  end

  describe "turnaround_time" do
    it "should return avg process turnaround time" do
      Scheduling::ProcessTable.stub!(:sum).with(:turnaround_time).and_return(19)
      Scheduling::ProcessTable.stub!(:size).and_return(2)
      Scheduling::OSReport.new.turnaround_time.should == 9.5
    end
  end

  describe "wait_time" do
    it "should return avg process wait time" do
      Scheduling::ProcessTable.stub!(:sum).with(:wait_time).and_return(5)
      Scheduling::ProcessTable.stub!(:size).and_return(2)
      Scheduling::OSReport.new.wait_time.should == 2.5
    end
  end
  
end