class Reader
  attr_reader :file
  
  def initialize(file_name)
    @file = File.open(file_name, 'r')
  end
  
  def next
    char = @file.getc
    return char.chr if char
    nil
  end
  
  def method_missing(sym, *args, &block)
    @file.send sym, *args, &block
  end
end