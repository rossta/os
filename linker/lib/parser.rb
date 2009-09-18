require File.dirname(__FILE__) + '/parsing'

class Parser
  include Parsing

  attr_accessor :linker
  
  def initialize(linker)
    @linker = linker
  end
  
  def symbols
    SymbolTable.symbols
  end
  
  def memory_map
    MemoryMap.memory
  end
  
  def errors
    @errors ||= {}
  end

  def reader
    linker.reader
  end
  
  def parse
    raise "Error: subclass must implement"
  end
end