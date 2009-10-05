require File.dirname(__FILE__) + '/spec_helper'

describe ProcessParser do
  
  describe "parse" do
    it "should create correct # of processes" do
      parser = ProcessParser.new(Reader.new(FIXTURES + "input_2.txt"))
      Process.should_receive(:new).exactly(:twice)
      parser.parse
    end
    it "should initialize processes with start values" do
      parser = ProcessParser.new(Reader.new(FIXTURES + "input_1.txt"))
      Process.should_receive(:new).with(0, 1, 5, 1)
      parser.parse
    end
  end
  
  describe "original_input" do
    it "should ignore comments" do
      parser = ProcessParser.new(mock(Reader, :read => "1 ( 0 1 5 1 )   comment", :rewind => nil))
      parser.original_input.should == "1 ( 0 1 5 1 )"
    end
    it "should return original input" do
      parser = ProcessParser.new(mock(Reader, :read => "1 ( 0 1 5 1 )", :rewind => nil))
      parser.original_input.should == "1 ( 0 1 5 1 )"
    end
  end
end
