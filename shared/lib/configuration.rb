class Configuration
  DUMMY_RANDOM_NUMBERS_FILE = File.dirname(__FILE__) + '/../config/random_numbers'
  
  def self.random_numbers_file=(file)
    @@random_numbers_file = file
  end
  
  def self.random_numbers_file
    @@random_numbers_file
  end
end