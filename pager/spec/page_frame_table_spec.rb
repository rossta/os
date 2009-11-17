require File.dirname(__FILE__) + '/spec_helper'

describe PageFrameTable do
  
  describe "free_frame" do
    describe "size 1" do
      before(:each) do
        @table = PageFrameTable.new(1)
      end
      it "should return a page frame if free" do
        @table.free_frame.should be_instance_of(PageFrame)
      end
      it "should return page frame 0 if free" do
        @table.free_frame.index.should == 0
      end
      it "should nil if frame 0 occupied" do
        @table.frames.first.stub!(:free?).and_return(false)
        @table.free_frame.index.should == 0
      end
    end
  end
end
