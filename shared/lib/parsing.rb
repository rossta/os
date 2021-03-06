module Parsing
  WHITE_SPACE = /[\s]/
  DIGIT       = /[\d]/
  WORD_CHAR   = /[\w]/
  SYMBOL      = /[\(\)]/
  
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
  
  def skip_symbol
    skip_white_space
    while SYMBOL.match @char
      @char = reader.next
    end
  end
  
end