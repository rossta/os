class Task
  attr_reader :number
  attr_accessor :total_time, :wait_time
  def initialize(number = nil)
    @number = number
    @total_time = 0
    @wait_time = 0
  end

  def add_activity(activity)
    activities << activity
  end

  def next_activity
    activities.detect { |a| !a.processed? }
  end

  def abort!
    ResourceTable.replenish(allocation)
    activities.each { |a| a.processed = true }
    @aborted = true
  end
  
  def aborted?
    @aborted
  end
  
  def allocation
    @allocation ||= {}
  end
  
  def allocate(type, units)
    allocation[type] = 0 unless allocation[type]
    allocation[type] += units
  end
  
  def release(type, units)
    release = {}
    allocation[type] -= units
    release[type] = units
    release
  end
  
  def wait
    @wait_time += 1
  end

  def terminated?
    activities.all? { |a| a.processed? }
  end

  def terminate_if_processed
    return if terminated?
    next_activity.process if next_activity.name == TaskActivity::TERMINATE
  end

  def activities
    @activities ||= []
  end

  def initial_claim
    @initial_claim ||= initiates
  end

  def percent_waiting
    (total_time > 0 ? (wait_time * 100 / total_time).ceil : 0)
  end
  
  def processable?
    !terminated? && !aborted?
  end
  
  def completed?
    terminated? && !aborted?
  end
  
  def report
    if aborted?
      "Task #{number} aborted"
    else
      "Task #{number} #{total_time} #{wait_time} #{percent_waiting}"
    end
  end

  def status
    if aborted?
      "Task #{number} aborted"
    else
      "Task #{number} #{allocation.inspect}"
    end
  end
  protected

  def initiates
    @initiates ||= activities.select { |a| a.name == TaskActivity::INITIATE }.sort_by { |a| a.resource_type }
  end
end