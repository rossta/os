class Linker
  attr_reader :reader
  
  def initialize(file_name)
    @reader = Reader.new(file_name)
  end
  
  def link
    clear!
    
    address_parser.parse
    memory_parser.parse
  end
  
  def errors
    @errors ||= {}
  end
  
  def clear!
    [SymbolTable, MemoryMap].each { |clearable| clearable.clear! }
  end
  
  def to_s
    output = SymbolTable.instance.to_s
    output += "\n\n"
    output += MemoryMap.instance.to_s
    output += "\n"
    output
  end
  
  def symbols
    SymbolTable.instance
  end
  
  def memory_map
    MemoryMap.instance
  end
  
private
  
  def address_parser
    @address_parser ||= AddressParser.new(self)
  end
  
  def memory_parser
    @memory_parser ||= MemoryParser.new(self)
  end
  
end