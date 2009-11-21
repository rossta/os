require File.dirname(__FILE__) + '/spec_helper'

describe Paging::Process do
  
  describe "page_reference" do
    before(:each) do
      size = 20
      page_size = 10
      @process = Paging::Process.new(size, page_size, 5)
    end
    it "should return page 0 referenced for word 5" do
      @process.page_reference(5).number.should == 0
    end
    it "should return page 1 references for word 11" do
      @process.page_reference(11).number.should == 1
    end
    it "should increment reference counter" do
      @process.page_reference(11).number.should == 1
      @process.references.should == 1
    end
  end
end
