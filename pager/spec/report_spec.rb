require File.dirname(__FILE__) + '/spec_helper'

describe Paging::Report do

  describe "base_report" do
    it "should summarize simulator inputs" do
      simulator = mock(Paging::Simulator,
        :machine_size => 20,
        :page_size    => 10,
        :process_size => 10,
        :job_mix_number => 2,
        :reference_rate => 10,
        :replacement_algorithm => "random",
        :debug_level    => 0)
      expected = <<-REPORT
The machine size is 20.
The page size is 10.
The process size is 10.
The job mix number is 2.
The number of references per process is 10.
The replacement algorithm is random.
The level of debugging output is 0
REPORT

      report = Paging::Report.new(simulator)
      report.base_report.should == expected.chomp
    end
  end

  describe "process_report" do
    it "should summarize process faults and residency" do
      Paging::ProcessTable.stub!(:processes).and_return([
        mock(Process, :faults => 2, :average_residency => 15.5),
        mock(Process, :faults => 4, :average_residency => 4.5)
      ])
      expected = <<-REPORT
Process 1 had 2 faults and 15.5 average residency.
Process 2 had 4 faults and 4.5 average residency.

The total number of faults is 6 and the overall average residency is 10.0.
REPORT
      
      report = Paging::Report.new(mock(Paging::Simulator))
      report.process_report.should == expected.chomp
    end
  end
end


