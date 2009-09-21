require File.dirname(__FILE__) + '/spec_helper'

describe Linker do
  describe "clear" do
    it "should clear the symbol table" do
      linker = Linker.new(FIXTURES + 'input_1.txt')
      SymbolTable.should_receive(:clear!)
      linker.clear!
    end
    it "should clear the memory map" do
      linker = Linker.new(FIXTURES + 'input_1.txt')
      MemoryMap.should_receive(:clear!)
      linker.clear!
    end
  end
  describe "link" do
    describe "inputs" do
      it "should match output 1 for input 1" do
        linker_output_should_match_expected_output_for("input_1")
      end
      it "should match output 2 for input 2" do
        linker_output_should_match_expected_output_for("input_2")
      end
      it "should match output 3 for input 3" do
        linker_output_should_match_expected_output_for("input_3")
      end
    end
  end
end

def linker_output_should_match_expected_output_for(input)
  linker = Linker.new(FIXTURES + "#{input}.txt")
  linker.link
  linker.to_s.should == File.open(FIXTURES + "output_#{input.match(/[0-9]+/)[0]}.txt").read
end