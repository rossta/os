class TaskParser
  include Parsing
  
  def initialize(file_name)
    @file_name = file_name
  end

  def parse
    reader.rewind
    @char = reader.next

    initialize_tasks_and_commands
    while @char
      read_task_command
    end
  end

  def tasks
    @tasks ||= []
  end

  def resources
    @resources ||= []
  end

  protected
  
  def initialize_tasks_and_commands
    num_tasks = parse_number
    num_tasks.times { tasks << Task.new }
    
    num_resources = parse_number
    num_resources.times do 
      resources << Resource.new(parse_number)
    end
  end
  
  def read_task_command
    instruction = parse_word
    task_index  = parse_number - 1
    task        = tasks[task_index]

    command = CommandFactory.create_for(instruction, self)
    task.add_command(command)
  end
  
  def reader
    @reader ||= Reader.new(@file_name)
  end

  class CommandFactory

    def self.create_for(instruction, parser)
      case instruction
      when Command::INITIATE
        Command::Initiate.new(parser.parse_number, parser.parse_number)
      when Command::REQUEST
        Command::Request.new(parser.parse_number, parser.parse_number)
      when Command::RELEASE
        Command::Release.new(parser.parse_number, parser.parse_number)
      when Command::COMPUTE
        Command::Compute.new(parser.parse_number)
      when Command::TERMINATE
        Command::Terminate.new
      end
    end
  end

end