require File.dirname(__FILE__) + '/spec_helper'

describe SchedulerCommand do
  describe "run" do
    it "should process input file 1" do
      command_report_should_match_output_file(1)
    end
    it "should process input file 2" do
      command_report_should_match_output_file(2)
    end
    it "should process input file 3" do
      command_report_should_match_output_file(3)
    end
    it "should process input file 4" do
      command_report_should_match_output_file(4)
    end
    it "should process input file 5" do
      pending
      command_report_should_match_output_file(5)
    end
  end
end

def command_report_should_match_output_file(index)
  command = SchedulerCommand.new
  command.run([FIXTURES + "input_#{index}.txt"])
  command.report.should == File.open(FIXTURES + "fifo/output_#{index}.txt").read.strip
end