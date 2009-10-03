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
  
  def line_count
    @line_count ||= readlines_count
  end
  
  def method_missing(sym, *args, &block)
    @file.send sym, *args, &block
  end
  
private
  def readlines_count
    @file.readlines
    count = @file.lineno
    @file.rewind
    count
  end
end