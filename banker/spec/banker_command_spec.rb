require File.dirname(__FILE__) + '/spec_helper'

describe BankerCommand do
  describe "run" do
    [1].each do |num|
      it "should process input file #{num}" do
        pending
        command = simulate_command num
        command.report.to_s.should == File.open(FIXTURES + "output_#{num}.txt").read.strip
      end
    end
    
    describe "expectations" do
      before(:each) do
        @parser = mock(TaskParser, :parse => nil, :tasks => [:tasks], :resources => [:resources])
        TaskParser.stub!(:new).and_return(@parser)
        @optimist     = mock(Optimist)
        @optimist_sim = mock(OptimistSimulator, :simulate! => nil, :manager => @optimist)
        OptimistSimulator.stub!(:new).and_return(@optimist_sim)
        @banker       = mock(Banker)
        @banker_sim = mock(BankerSimulator, :simulate! => nil, :manager => @banker)
        BankerSimulator.stub!(:new).and_return(@banker_sim)
        @report       = mock(BankerReport, :to_s => "report")
        BankerReport.stub!(:new).and_return(@report)
      end
      it "should simulate banker" do
        @banker_sim.should_receive(:simulate!).and_return(nil)
        @banker_sim.should_receive(:manager).and_return(@optimist)
        simulate_command 1
      end
      it "should simulate optimist" do
        @optimist_sim.should_receive(:simulate!).and_return(nil)
        @optimist_sim.should_receive(:manager).and_return(@optimist)
        simulate_command 1
      end
      it "should parse parser" do
        @parser.should_receive(:parse).and_return(nil)
        simulate_command 1
      end
      it "should report" do
        @report.should_receive(:to_s).and_return("report")
        report = simulate_command(1).report
        report.to_s.should == "report"
      end
    end
  end
end

def simulate_command(index)
  command = BankerCommand.new
  command.run(FIXTURES + "input_#{index}.txt")
end

