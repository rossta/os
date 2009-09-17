class Linker
  attr_reader :reader
  attr_accessor :symbols, :modules
  
  def initialize(file_name)
    @reader = Reader.new(file_name)
  end
  
  def link
    parse_addresses
    parse_memory
    
    map_memory
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
  
  def to_s
    symbols_to_s + "\n" + modules_to_s + "\n"
  end
  
private
  
  def parse_addresses
    address_parser = AddressParser.new(linker)
    address_parser.parse
  end
  
  def parse_memory
    memory_parser = MemoryParser.new(linker)
    memory_parser.parse
  end
  
  def map_memory
    
  end
  
  def symbols_to_s
    "Symbol Table"
  end
  
  def modules_to_s
    "Memory Map"
  end
end