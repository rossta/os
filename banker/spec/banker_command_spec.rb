require File.dirname(__FILE__) + '/spec_helper'

describe BankerCommand do
  describe "run" do
    # [1].each do |num|
    #   it "should process input file #{num}" do
    #     pending
    #     command = simulate_command num
    #     command.report.to_s.should == File.open(FIXTURES + "output_#{num}.txt").read.strip
    #   end
    # end
  end
end

def simulate_command(index)
  command = BankerCommand.new
  command.simulate(FIXTURES + "input_#{index}.txt")
  command
end

