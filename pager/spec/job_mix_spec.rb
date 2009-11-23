require File.dirname(__FILE__) + '/spec_helper'

describe Paging::JobMix do
  describe "self.create" do
    it "should return one process with A=1 and B=C=0 for job mix 1" do
      job_mix = Paging::JobMix.create(1)
      job_mix.size.should == 1
      job_mix.a.should == 1.0
      job_mix.b.should == 0
      job_mix.c.should == 0
    end
    it "should return four processes, each with A=1 and B=C=0. for job mix 2" do
      job_mix = Paging::JobMix.create(2)
      job_mix.size.should == 4
      job_mix.a.should == 1.0
      job_mix.b.should == 0
      job_mix.c.should == 0
    end
    it "should return four processes, each with A=B=C=0. for job mix 3" do
      job_mix = Paging::JobMix.create(3)
      job_mix.size.should == 4
      job_mix.a.should == 0
      job_mix.b.should == 0
      job_mix.c.should == 0
    end
    
    it "should return one process with A=.75, B=.25 and C=0; one process with A=.75, B=0, and C=.25; one process with A=.75, B=.125 and C=.125; and one process with A=.5, B=.125 and C=.125." do
      job_mix = Paging::JobMix.create(3)
    end
  end
  
  
end
