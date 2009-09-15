require File.dirname(__FILE__) + '/../../rspec/spec/spec_helper'
Dir.glob(File.join(File.dirname(__FILE__), '/../lib/*.rb')).each {|f| require f }

FIXTURES = File.dirname(__FILE__) + '/fixtures/'

def create_basic_file(file_name)
  File.open(file_name, 'w') {|f| f.write("") }
  
  file = File.open(file_name, 'w+')
  file.puts("1 xy 2\n")
  file.puts("2 z xy\n")
  file.puts("5 R 1004  I 5678  E 2000  R 8002  E 7001\n")
  file.rewind
end