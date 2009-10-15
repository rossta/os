require File.dirname(__FILE__) + '/lib/env'

app = Runner.new(ARGV, SchedulerCommand.new)
app.run