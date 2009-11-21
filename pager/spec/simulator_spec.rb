require File.dirname(__FILE__) + '/spec_helper'

describe Paging::Simulator do
  
  describe "self.random_quotient" do
    it "should return random_number / DENOMINATOR" do
      number      = 1804289383
      denominator = 2147483648.to_f
      Paging::Simulator.random_quotient.should == (number / denominator)
    end
  end

  
end