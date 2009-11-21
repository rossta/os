module Paging
  class JobMix
    # J=1: One process with A=1 and B=C=0, the simplest (fully sequential) case.
    # J=2: Four processes, each with A=1 and B=C=0.
    # J=3: Four processes, each with A=B=C=0 (fully random references).
    # J=4: One process with A=.75, B=.25 and C=0; one process with A=.75, B=0, and C=.25; one process with A=.75, B=.125 and C=.125; and one process with A=.5, B=.125 and C=.125.
    def self.create(number)
      new(number)
    end

    attr_reader :number
    def initialize(number)
      @number = number
    end

    def size
      1
    end

    def a
      1.0
    end

    def b
      0
    end

    def c
      0
    end
  end
end
