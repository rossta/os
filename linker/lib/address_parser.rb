require File.dirname(__FILE__) + '/parsing'

class AddressParser
  include Parsing
  
  attr_reader :reader
  attr_accessor :base_address, :modules, :symbols, :errors
  
  def initialize(reader)
    @reader = reader
    @base_address = 0
  end
  
  def symbols
    @symbols ||= {}
  end
  
  def modules
    @modules ||= []
  end
  
  def errors
    @errors ||= {}
  end
  
  def parse
    while (@char = reader.next)
      detect_symbols
      detect_base_addresses
    end
  end

private

  def detect_symbols
    parse_number.times do |i|
      symbol           = parse_word
      if symbols[symbol]
        errors[symbol] = "This variable is multiply defined; first value used."
      else
        symbols[symbol] = parse_number + @base_address
      end
    end
  end
  
  def detect_base_addresses
    skip_use_list
    skip_program(module_size = parse_number)
    @base_address += module_size
    modules << ObjectModule.new(@base_address)
  end
  
  def skip_use_list
    parse_number.times { |i| parse_word }
  end
  
  def skip_program(count = 0)
    count.times do |i|
      parse_word
      parse_number
    end
  end
    
end