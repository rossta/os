class AddressParser
  WHITE_SPACE = /[ \n\r]/
  DIGIT       = /[0-9]/
  WORD_CHAR   = /[A-Za-z0-9_]/
  
  attr_reader :reader
  
  def initialize(reader)
    @reader = reader
  end
  
  def symbols
    @symbols ||= {}
  end
  
  def modules
    @modules ||= []
  end
  
  def base_address
    @base_address ||= 0
  end
  
  def parse
    while (@char = reader.next)
      consume_module
    end
  end

private

  def consume_module
    detect_symbols
    detect_module_size
  end
  
  def detect_symbols
    parse_number.times do |i|
      symbol           = parse_word
      symbols[symbol]  = parse_number + base_address
    end
  end
  
  def detect_module_size
    skip_use_list
    module_size = parse_number
    @base_address += module_size
    skip_program(module_size)
    modules << ObjectModule.new(module_size)
  end
  
  def skip_use_list
    skip_words(parse_number)
  end
  
  def skip_words(count = 1)
    count.times { |i| parse_word }
  end
  
  def skip_program(count = 0)
    count.times do |i|
      parse_word
      parse_number
    end
  end
  
  def parse_number
    skip_white_space
    num = ''
    while DIGIT.match @char
      num += @char
      @char = reader.next
    end
    num.to_i
  end
  
  def parse_word
    skip_white_space
    word = ''
    while WORD_CHAR.match @char
      word += @char
      @char = reader.next
    end
    word
  end
  
  def skip_white_space
    while WHITE_SPACE.match @char
      @char = reader.next
    end
  end
  
end