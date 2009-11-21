module Paging
  class Simulator

    attr_reader :machine_size, :page_size, :process_size, :job_mix, :reference_rate, :replacement_algorithm, :debug_level
    attr_accessor :word

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
      @job_mix      = Paging::JobMix.create(arguments.shift.to_i)
      @reference_rate = arguments.shift.to_i
      @replacement_algorithm = arguments.shift.downcase
      @debug_level  = arguments.shift || "0"

      initialize_processes
      RandomNumberGenerator.clear!
      Logger.init(@debug_level)
    end

    def run
      Clock.start
      process = ProcessTable.processes.first

      word = (111 * process.number).modulo(self.process_size)

      while !terminated? do
        cycle_clock
        # select process

        # select page frame, determine fault/hit
        page    = process.page_reference(word)
        result  = ["#{process.number} references word #{word} (page #{page.number}) at time #{Clock.time}:"]
        
        if (frame = page_frames.find_frame(page))
          result << "Hit in frame #{frame.index}."
        else
          if (frame = page_frames.find_page_evict_frame)
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
        quotient = random_quotient(process.number)

        word = (word + 1).modulo(self.process_size) # case 1

      end
    end

    def page_frames
      @page_frames ||= PageFrameTable.new(self.machine_size/self.page_size)
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

    DENOMINATOR = 2147483648
    def self.random_quotient(process_num = 1)
      number = RandomNumberGenerator.number
      Logger.record "#{process_num} uses random number: #{number}", :level => :verbose
      number / DENOMINATOR.to_f
    end
    
    def random_quotient(process_num = 1)
      self.class.random_quotient(process_num)
    end

    protected

    def cycle_clock
      Clock.cycle       unless terminated?
    end

    def initialize_processes
      ProcessTable.clear!
      processes = Array.new(self.job_mix.size) { |i| Process.new(self.process_size, self.page_size, self.reference_rate, i) }
      ProcessTable.load_processes(processes)
    end
  end
end