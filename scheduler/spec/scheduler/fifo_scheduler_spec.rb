require File.dirname(__FILE__) + '/../spec_helper'

describe Scheduling::FifoScheduler do
  describe "preempt?" do
    it "should return false always" do
      scheduler = Scheduling::FifoScheduler.new
      scheduler.preempt?.should be_false
    end
  end
end
