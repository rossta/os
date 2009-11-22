module Paging
  class ReplacementStrategy
    def self.create(name)
      case name.downcase.to_sym
      when :lru
        
      when :random
      when :lifo
      else
        raise "Replacement algorithm not recognized. Please use one of: lru, random, lifo"
      end
    end
  end
  
  class LRUStrategy
  end
  
  class RandomStrategy
  end
  
  class LifoStrategy
  end
end