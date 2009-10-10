class RandomNumberGenerator
  RANDOM_NUMBERS_FILE = File.dirname(__FILE__) + '/../config/random_numbers'
  
  def self.number
    instance.number
  end
  
  def self.clear!
    @@instance = RandomNumberGenerator.new
  end
  
  def self.instance
    @@instance ||= RandomNumberGenerator.new
  end
  
  def initialize
    @reader = Reader.new(RANDOM_NUMBERS_FILE)
  end
  
  def number
    @reader.readline.strip.to_i
  end
  
end