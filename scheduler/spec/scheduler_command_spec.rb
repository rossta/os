require File.dirname(__FILE__) + '/spec_helper'

describe SchedulerCommand do
  describe "run" do
    describe "FIFO" do
      [1,2,3,4,5,6,7].each do |num|
        it "should process input file #{num}" do
          # command_report_should_match_output_file(num)
        end
      end
    end
    describe "RR" do
      [1,2,3].each do |num|
        it "should process input file #{num}" do
          # command_report_should_match_output_file(num, "rr")
        end
      end
      [4].each do |num|
        it "should process input file #{num}" do
          command_report_should_match_output_file(num, "rr")
        end
      end
    end
  end
end

def command_report_should_match_output_file(index, strategy = "fifo")
  command = SchedulerCommand.new
  command.simulate([FIXTURES + "input_#{index}.txt", strategy])
  command.report.should == File.open(FIXTURES + "#{strategy}/output_#{index}.txt").read.strip
end