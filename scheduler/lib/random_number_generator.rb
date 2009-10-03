class RandomNumberGenerator
  RANDOM_NUMBERS_FILE = File.dirname(__FILE__) + '/../config/random_numbers'
  
  def initialize
    @reader = Reader.new(RANDOM_NUMBERS_FILE)
  end
  
  def number
    number = @reader.readlines[rand(count)].strip.to_i
    @reader.rewind
    number
  end
  
  def count
    @reader.line_count
  end

end