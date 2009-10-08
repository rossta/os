require File.dirname(__FILE__) + '/spec_helper'

describe SchedulerCommand do
  describe "run" do
    it "should parse input file" do
      # pending
      command = SchedulerCommand.new
      command.run([FIXTURES + "input_1.txt"])
      command.report.should == File.open(FIXTURES + "fifo/output_1.txt").read.strip
    end
  end
end
