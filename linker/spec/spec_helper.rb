require File.dirname(__FILE__) + '/../../rspec/spec/spec_helper'
Dir.glob(File.join(File.dirname(__FILE__), '/../lib/*.rb')).each {|f| require f }