require File.dirname(__FILE__) + '/spec_helper'

describe PagerReport do

  describe "base_report" do
    it "should match expected output" do
      pager = mock(Pager,
        :machine_size => 20,
        :page_size    => 10,
        :process_size => 10,
        :job_mix      => 2,
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

      report = PagerReport.new(pager)
      report.base_report.should == expected.chomp
    end
  end

  describe "process_report" do
    it "should description" do

    end
  end
end


# Process 1 had 2 faults and 15.5 average residency.
# Process 2 had 4 faults and 5.0 average residency.
# Process 3 had 4 faults and 2.5 average residency.
# Process 4 had 4 faults and 5.666666666666667 average residency.
#
# The total number of faults is 14 and the overall average residency is 6.083333333333333.
