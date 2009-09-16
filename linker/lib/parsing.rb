module Parsing
  WHITE_SPACE = /[ \n\r]/
  DIGIT       = /[0-9]/
  WORD_CHAR   = /[A-Za-z0-9_]/
  
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