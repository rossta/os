require File.dirname(__FILE__) + '/spec_helper'

describe Reader do
  describe "line_count" do
    before(:each) do
      @file = mock(File, :lineno => 4, :rewind => nil, :readlines => %w|1 2 3 4|)
      File.stub!(:open).and_return(@file)
    end
    it "should count no of lines" do
      reader = Reader.new("/foo")
      reader.line_count.should == 4
    end
    
    it "should rewind file" do
      reader = Reader.new("/foo")
      @file.should_receive(:readlines).once.ordered
      @file.should_receive(:rewind).once.ordered
      reader.line_count
    end
  end
end
