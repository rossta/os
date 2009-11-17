class PagerRunner < Runner
  VERSION = '0.0.1'
  VALID_ALGORITHMS = %w|LIFO RANDOM LRU|
  
  def initialize(arguments, command)
    @arguments = arguments
    @command = command
  end

  def run
    if arguments_valid?
      process_command
    else
      output_usage
    end

  end

protected

  def arguments_valid?
    integer_list  = @arguments.slice(0..4)
    algorithm     = @arguments.slice(5)
    Logger.debug(@arguments.slice(6).to_i > 0)

    return false if integer_list.size != 5
    return false if algorithm.nil?
    integer_list.all? { |i| i.to_i > 0 } && VALID_ALGORITHMS.include?(algorithm.upcase)
  end

  def output_usage
    usage =   ["Usage:"]
    usage <<  "ruby [path...]/run [M] [P] [S] [J] [N] [R] [d: 0 | 1]"
    usage <<  "M, the machine size in words."
    usage <<  "P, the page size in words."
    usage <<  "S, the size of a processes, i.e., the references are to virtual addresses 0..S-1."
    usage <<  "J, the ‘job mix’, which determines A, B, and C, as described below."
    usage <<  "N, the number of references for each process."
    usage <<  "R, the replacement algorithm, LIFO (NOT FIFO), RANDOM, or LRU."
    usage <<  "d, 0 for quiet, 1 for debug"
    puts usage.join("\n\t")
  end

  def process_command
    @command.run(@arguments)
  end

end
