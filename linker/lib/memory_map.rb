class MemoryMap
  
  def self.memory
    @@memory ||= MemoryMap.new
  end
  
  def self.clear!
    @@memory = MemoryMap.new
  end
  
  def self.create_program_module(base_address, symbols = {})
    program_module = ProgramModule.new(base_address)
    program_module.symbols = symbols
    MemoryMap.memory << program_module
  end
  
  def self.validate!
    uses = memory.modules.map { |m| m.uses }.flatten!.uniq
    unused_symbols = SymbolTable.symbols.keys.find_all { |sym| !uses.include?(sym) }
    
    unused_symbols.sort.each do |sym|
      warnings << "Warning: #{sym} was defined in module #{module_index(sym)} but never used."
    end
  end
  
  def self.warnings
    memory.warnings
  end
  
  attr_reader :modules
  
  def initialize
    @modules = []
  end
  
  def [](index)
    @modules[index]
  end
  
  def map
    @modules.each { |m| m.map }
  end
  
  def to_s
    result = ["Memory Map"]
    @modules.each do |program_module|
      result << program_module.to_s
    end
    result.join("\n")
  end
  
  def warnings
    @warnings ||= []
  end
  
  def method_missing(sym, *args, &block)
    @modules.send sym, *args, &block
  end
  
protected
  
  def self.module_index(symbol)
    program_module = memory.modules.detect { |pm| pm.defines?(symbol) }
    memory.modules.index(program_module) + 1
  end
  
end