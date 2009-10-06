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
      Scheduling::Process.should_receive(:new).with(0, 1, 5, 1)
      parser.parse
    end
  end
  
  describe "to_s" do
    it "should print one process" do
      parser = ProcessParser.new
      parser.processes << mock(Process, :to_s => '( 0 1 5 1 )')
      parser.send(:to_s).should == "1 ( 0 1 5 1 )"
    end
    it "should print multiple processes" do
      parser = ProcessParser.new
      parser.processes << mock(Process, :to_s => '( 0 1 5 1 )')
      parser.processes << mock(Process, :to_s => '( 0 1 5 1 )')
      parser.to_s.should == "2 ( 0 1 5 1 ) ( 0 1 5 1 )"
    end
  end
end
