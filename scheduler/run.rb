require File.dirname(__FILE__) + '/lib/env'

# Create and run the application
app = Runner.new(ARGV, SchedulerCommand.new)
app.run