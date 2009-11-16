RANDOM_NUMBERS_FILE = File.dirname(__FILE__) + '/../../shared/config/scheduler/random_numbers'

require File.dirname(__FILE__) + '/../../shared/lib/env'
Dir.glob(File.join(File.dirname(__FILE__), '/*.rb')).each {|f| require f }
Dir.glob(File.join(File.dirname(__FILE__), '/*/*.rb')).each {|f| require f }

