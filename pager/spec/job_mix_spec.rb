require File.dirname(__FILE__) + '/spec_helper'

describe Paging::JobMix do
  describe "self.create" do
    it "should return 4 processes, A=1 for number 1" do
      job_mix = Paging::JobMix.create(1)
      job_mix.size.should == 4
      job_mix.a.should == 1.0
      job_mix.b.should == 0
      job_mix.c.should == 0
    end
  end
end
