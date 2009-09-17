require File.dirname(__FILE__) + '/spec_helper'

describe Linker do
  
  describe "input 1" do
    it "should match output 1" do
      pending
      linker = Linker.new(FIXTURES + 'input_4.txt')
      linker.link
      linker.to_s.should == File.open(FIXTURES + 'output_1.txt').read
    end
  end
end
