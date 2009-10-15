require File.dirname(__FILE__) + '/lib/env'

app = SchedulerRunner.new(ARGV, SchedulerCommand.new)
app.run