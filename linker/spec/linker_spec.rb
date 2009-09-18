require File.dirname(__FILE__) + '/spec_helper'

describe Linker do
  
  describe "input 1" do
    it "should match output 1" do
      linker = Linker.new(FIXTURES + 'input_1.txt')
      linker.link
      linker.to_s.should == File.open(FIXTURES + 'output_1.txt').read
    end
  end
end
