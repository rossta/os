class SchedulerCommand
  def run(arguments)
    scheduler = Scheduler.new(arguments.first)
    puts scheduler.to_s
  end
end