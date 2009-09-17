class SymbolTable
  
  def initialize
    @symbols = {}
  end
  
  def []=(key, value)
    @symbols[key] = value
  end
  
  def [](key)
    @symbols[key]
  end
  
  def to_s
    result = ["Symbol Table"]
    @symbols.each do |key, value|
      text = "#{key.to_s}=#{value.to_s}"
      text += " " + errors[key] if !errors[key].nil?
      result << text
    end
    result.join("\n") + "\n"
  end
  
  def errors
    @errors ||= {}
  end
  
  def method_missing(sym, *args, &block)
    @symbols.send sym, *args, &block
  end
end