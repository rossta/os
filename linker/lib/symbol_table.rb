class SymbolTable

  def self.instance
    @@table ||= SymbolTable.new
  end

  def self.clear!
    @@table = SymbolTable.new
  end
  
  def self.symbols
    instance.symbols
  end
  
  def self.defines?(symbol)
    !address(symbol).nil?
  end
  
  def self.address(symbol)
    instance[symbol]
  end
  
  def self.errors
    instance.errors
  end

  attr_accessor :symbols

  def []=(key, value)
    @symbols[key] = value
  end

  def [](key)
    @symbols[key]
  end
  
  def to_s
    result = ["Symbol Table"]
    @symbols.sort.each do |pair|
      key = pair[0]
      val = pair[1]
      text = "#{key.to_s}=#{val.to_s}"
      text += " " + errors[key] if !errors[key].nil?
      result << text
    end
    result.join("\n")
  end
  
  def errors
    @errors ||= {}
  end

  def warnings
    @warnings ||= []
  end

  def method_missing(sym, *args, &block)
    @symbols.send sym, *args, &block
  end

  def initialize
    @symbols = {}
  end

end