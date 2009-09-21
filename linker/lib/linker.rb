class Linker
  attr_reader :reader
  
  def initialize(file_name)
    @reader = Reader.new(file_name)
  end
  
  def link
    clear!
    
    address_parser.parse
    memory_parser.parse
    
    MemoryMap.memory.map
    MemoryMap.validate!
  end
  
  def errors
    @errors ||= {}
  end
  
  def clear!
    [SymbolTable, MemoryMap].each { |clearable| clearable.clear! }
  end
  
  def to_s
    output = SymbolTable.table.to_s
    output += "\n" + "\n"
    output += MemoryMap.memory.to_s
    output += "\n"
    output += "\n" + MemoryMap.warnings.join("\n") + "\n" if !MemoryMap.warnings.empty?
    output
  end
  
  def symbols
    SymbolTable.table
  end
  
  def memory_map
    MemoryMap.memory
  end
  
private
  
  def address_parser
    @address_parser ||= AddressParser.new(self)
  end
  
  def memory_parser
    @memory_parser ||= MemoryParser.new(self)
  end
  
end