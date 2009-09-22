require File.dirname(__FILE__) + '/parser'

class AddressParser < Parser
  attr_accessor :base_address
  
  def initialize(linker)
    @base_address = 0
    super(linker)
  end
   
  def parse
    while (@char = reader.next)
      detect_symbols_and_base_addresses
    end
    reader.file.rewind
  end

private

  def detect_symbols_and_base_addresses
    # symbols
    module_symbols = {}
    parse_number.times do |i|
      symbol           = parse_word
      if SymbolTable.defines?(symbol)
        SymbolTable.errors[symbol] = "Error: This variable is multiply defined; first value used."
      else
        module_symbols[symbol] = parse_number + @base_address
        SymbolTable.table[symbol] = module_symbols[symbol]
      end
    end
    
    # base_addresses
    skip_use_list
    skip_program(module_size = parse_number)
    
    MemoryMap.create_program_module(@base_address, module_symbols)
    
    @base_address += module_size
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