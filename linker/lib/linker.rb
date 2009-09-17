class Linker
  attr_reader :reader
  
  def initialize(file_name)
    @reader = Reader.new(file_name)
  end
  
  def link
    address_parser.parse
    memory_parser.parse
    
    memory_map.map
  end
  
  def symbols
    @symbols ||= SymbolTable.new
  end
  
  def memory_map
    @memory_map ||= MemoryMap.new
  end
  
  def errors
    @errors ||= {}
  end
  
  def to_s
    symbols.to_s + memory_map.to_s
  end
  
private
  
  def address_parser
    @address_parser ||= AddressParser.new(self)
  end
  
  def memory_parser
    @memory_parser ||= MemoryParser.new(self)
  end
  
end