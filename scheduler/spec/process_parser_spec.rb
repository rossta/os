require File.dirname(__FILE__) + '/spec_helper'

describe ProcessParser do
  
  describe "parse" do
    it "should create correct # of processes" do
      parser = ProcessParser.new((FIXTURES + "input_2.txt"))
      Scheduling::Process.should_receive(:new).exactly(:twice)
      parser.parse
    end
    it "should initialize processes with start values" do
      parser = ProcessParser.new((FIXTURES + "input_1.txt"))
      Scheduling::Process.should_receive(:new).with(0, 1, 5, 1, 0)
      parser.parse
    end
  end
  
end
