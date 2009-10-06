class RandomNumberGenerator
  RANDOM_NUMBERS_FILE = File.dirname(__FILE__) + '/../config/random_numbers'
  
  def initialize
    @reader = Reader.new(RANDOM_NUMBERS_FILE)
  end
  
  def number
    @reader.readline.strip.to_i
  end
  
end