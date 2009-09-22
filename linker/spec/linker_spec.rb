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
      it "should match output 4 for input 4" do
        linker_output_should_match_expected_output_for("input_4")
      end
      it "should match output 5 for input 5" do
        linker_output_should_match_expected_output_for("input_5")
      end
      it "should match output 6 for input 6" do
        linker_output_should_match_expected_output_for("input_6")
      end
      it "should match output 7 for input 7" do
        linker_output_should_match_expected_output_for("input_7")
      end
      it "should match output 8 for input 8" do
        linker_output_should_match_expected_output_for("input_8")
      end
      # it "should match output 9 for input 9" do
      #   # Relative exceeds mem size error
      #   pending 
      #   linker_output_should_match_expected_output_for("input_9")
      # end
    end
  end
end

def linker_output_should_match_expected_output_for(input)
  linker = Linker.new(FIXTURES + "#{input}.txt")
  linker.link
  linker.to_s.should == File.open(FIXTURES + "output_#{input.match(/[0-9]+/)[0]}.txt").read
end