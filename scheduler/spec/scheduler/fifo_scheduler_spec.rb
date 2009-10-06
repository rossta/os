require File.dirname(__FILE__) + '/../spec_helper'

describe FifoScheduler do
  
  describe "to_s" do
    describe "input_1" do
      it "should match output_1" do
        scheduler = FifoScheduler.new(FIXTURES + "input_1.txt")
        scheduler.run
        scheduler.to_s.should == File.open(FIXTURES + "fifo/output_1.txt").read
      end
    end
  end
end

# def linker_output_should_match_expected_output_for(input)
#   linker = Linker.new(FIXTURES + "#{input}.txt")
#   linker.link
#   linker.to_s.should == File.open(FIXTURES + "output_#{input.match(/[0-9]+/)[0]}.txt").read
# end