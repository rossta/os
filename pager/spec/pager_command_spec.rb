require File.dirname(__FILE__) + '/spec_helper'

describe PagerCommand do
  
  describe "base_report" do
    before(:each) do
      @command = PagerCommand.new
    end
    describe "input 1: 10 10 20 1 10 lru 0" do
      it "should produce expected output" do
        input = %w|10 10 20 1 10 lru 0|
        @command.run(input)
        expected_output = <<-REPORT
The machine size is 10.
The page size is 10.
The process size is 20.
The job mix number is 1.
The number of references per process is 10.
The replacement algorithm is lru.
The level of debugging output is 0
        REPORT
        @command.report.base_report.should == expected_output.chomp
      end
    end
  end
end