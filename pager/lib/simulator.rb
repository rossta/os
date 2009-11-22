module Paging
  class Simulator
    QUANTUM = 3

    def run
      Clock.start
      self.process = ProcessTable.processes.first

      while !terminated? do
        cycle_clock

        # select page frame, determine fault/hit
        word    = process.word
        page    = process.page_reference
        result  = ["#{process.number} references word #{word} (page #{page.number}) at time #{Clock.time}:"]

        if (frame = page_frames.find_frame(page))
          result << "Hit in frame #{frame.index}."
        else
          if (frame = page_frames.find_eviction_frame)
            result << "Fault, evicting page #{frame.page_number} of #{frame.process_number} from frame #{frame.index}."
            frame.evict_page!
            page_frames.load_frame(frame, page)
          else
            frame = page_frames.load_new_frame(page)
            result << "Fault, using free frame #{frame.index}."
          end
          process.increment_faults
        end

        Logger.record result.join(" ")

        # calculate word reference using random quotient
        quotient = RandomNumberGenerator.quotient

        process.word = (process.word + 1).modulo(process_size) # case 1

        if context_switch?(process)
          self.process = switch(process)
        end
      end
    end

    attr_reader :machine_size, :page_size, :process_size, :job_mix, :reference_rate, :replacement_algorithm, :debug_level
    attr_accessor :process

    def initialize(arguments)
      # M, the machine size in words.
      # P, the page size in words.
      # S, the size of a processes, i.e., the references are to virtual addresses 0..S-1.
      # J, the ‘‘job mix’’, which determines A, B, and C, as described below.
      # N, the number of references for each process.
      # R, the replacement algorithm, LIFO, RANDOM, or LRU.

      @machine_size = arguments.shift.to_i
      @page_size    = arguments.shift.to_i
      @process_size = arguments.shift.to_i
      @job_mix      = JobMix.create(arguments.shift.to_i)
      @reference_rate = arguments.shift.to_i
      @replacement_algorithm = arguments.shift.downcase
      @debug_level  = arguments.shift || "0"

      initialize_processes
      RandomNumberGenerator.clear!
      RandomNumberGenerator.register_observer(self)
      Logger.init(@debug_level)
    end

    def page_frames
      @page_frames ||= initialize_page_frame_table
    end

    def word_reference(&block)
      @word = block.call(@word)
    end

    def terminated?
      ProcessTable.terminated?
    end

    def job_mix_number
      self.job_mix.number
    end

    def random_number_used(number)
      Logger.record "#{process.number} uses random number: #{number}", :level => :verbose
    end

    # TODO deprecated
    DENOMINATOR = 2147483648
    def self.random_quotient(process)
      ("%0.1f" % (RandomNumberGenerator.number / DENOMINATOR.to_f)).to_f
    end

    # TODO deprecated
    def random_quotient(process_num = 1)
      self.class.random_quotient(process_num)
    end

    def switch(process)
      ProcessTable.rotate(process)
    end

    def context_switch?(process)
      return false if self.job_mix.size == 1
      Clock.time.modulo(QUANTUM) == 0 || process.terminated?
    end

    protected

    def cycle_clock
      Clock.cycle       unless terminated?
    end

    def initialize_processes
      ProcessTable.clear!
      processes = Array.new(self.job_mix.size) do |i|
        Process.new(self.process_size, self.page_size, self.reference_rate, i)
      end
      ProcessTable.load_processes(processes)
    end

    def initialize_page_frame_table
      size = self.machine_size/self.page_size
      case replacement_algorithm.to_sym
      when :lru
        PageFrameTable.new(size) do |frames|
          frames.sort.first
        end
      else
        raise "Replacement algorithm not recognized"
      end
    end
  end
end