require File.dirname(__FILE__) + '/../../shared/lib/env'
Dir.glob(File.join(File.dirname(__FILE__), '/*.rb')).each {|f| require f }
Dir.glob(File.join(File.dirname(__FILE__), '/*/*.rb')).each {|f| require f }

Configuration.random_numbers_file = File.dirname(__FILE__) + '/../../scheduler/config/random_numbers'
