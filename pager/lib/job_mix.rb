module Paging
  module JobMix
    def self.create(number)
      case number
      when 1
        One.new
      when 2
        Two.new
      when 3
        Three.new
      when 4
        Four.new
      else
        raise "Invalid job mix number; choose 1, 2, 3 or 4"
      end
    end

    class Base
      # w+1 mod S with probability A
      # w-5 mod S with probability B
      # w+4 mod S with probability C
      # random Y mod S

      attr_accessor :process
      def size
        1
      end

      def a
        1.0
      end

      def b
        0.0
      end

      def c
        0.0
      end

      def a_b
        a + b
      end

      def a_b_c
        a + b + c
      end

    end

    class One < Base
      # J=1: One process with A=1 and B=C=0, the simplest (fully sequential) case.
      def number
        1
      end
    end

    class Two < Base
      # J=2: Four processes, each with A=1 and B=C=0.
      def number
        2
      end

      def size
        4
      end
    end

    class Three < Base
      # J=3: Four processes, each with A=B=C=0 (fully random references).
      def number
        3
      end

      def a
        0.0
      end

      def size
        4
      end

    end

    class Four < Base
      # J=4:
      # one process with A=.75, B=.25   and C=0;
      # one process with A=.75, B=0,    and C=.25;
      # one process with A=.75, B=.125  and C=.125;
      # one process with A=.50, B=.125  and C=.125.

      def number
        4
      end

      def size
        4
      end

      def a
        case process.number
        when 4
          0.50
        else
          0.75
        end
      end

      def b
        case process.number
        when 1
          0.25
        when 2
          0.0
        else
          0.125
        end
      end

      def c
        case process.number
        when 1
          0.0
        when 2
          0.25
        else
          0.125
        end
      end
    end
  end
end
