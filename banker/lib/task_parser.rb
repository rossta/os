class TaskParser
  include Parsing
  
  def initialize(file_name)
    @file_name = file_name
  end

  def parse
    reader.rewind
    @char = reader.next

    initialize_tasks_and_activities
    while @char = reader.next
      read_task_activity
    end
  end

  def tasks
    @tasks ||= []
  end

  def resources
    @resources ||= []
  end

  protected
  
  def initialize_tasks_and_activities
    num_tasks = parse_number
    num_tasks.times { |i| tasks << Task.new(i + 1) }
    
    num_resources = parse_number
    num_resources.times do |index|
      units = parse_number
      type  = index + 1
      resources << Resource.new(units, type)
    end
  end
  
  def read_task_activity
    instruction = parse_word
    task_index  = parse_number - 1
    task        = tasks[task_index]

    activity = ActivityFactory.create_for(task, instruction, self)
    task.add_activity(activity)
  end
  
  def reader
    @reader ||= Reader.new(@file_name)
  end

  class ActivityFactory

    def self.create_for(task, instruction, parser)
      case instruction
      when TaskActivity::INITIATE
        TaskActivity::Initiate.new(task, parser.parse_number, parser.parse_number)
      when TaskActivity::REQUEST
        TaskActivity::Request.new(task, parser.parse_number, parser.parse_number)
      when TaskActivity::RELEASE
        TaskActivity::Release.new(task, parser.parse_number, parser.parse_number)
      when TaskActivity::COMPUTE
        TaskActivity::Compute.new(task, parser.parse_number)
      when TaskActivity::TERMINATE
        TaskActivity::Terminate.new(task)
      end
    end
  end

end