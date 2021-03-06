class Task
  attr_reader :number
  attr_accessor :total_time, :wait_time, :allocation, :aborted
  def initialize(number = nil)
    @number = number
    @total_time = 0
    @wait_time = 0
  end
  
  def reset!
    activities.each { |a| a.reset! }
    self.total_time = 0
    self.wait_time = 0
    self.allocation = {}
    self.aborted = false
  end

  def add_activity(activity)
    activities << activity
  end

  def next_activity
    activities.detect { |a| !a.processed? }
  end
  
  def safe?
    safe = true
    initial_claim.each do |initiate|
      available = ResourceTable.available_units(initiate.resource_type)
      remaining = initiate.units - (allocation[initiate.resource_type] || 0)
      safe = safe && (available >= remaining)
    end
    safe
  end
  
  def remaining_units(type)
    remaining_requests = requests.select { |r| r.resource_type == type && !r.processed? }
    remaining_requests.inject(0) { |sum, r| sum + r.units }
  end
  
  def consumed_units(type)
    remaining_requests = requests.select { |r| r.resource_type == type && r.processed? }
    remaining_requests.inject(0) { |sum, r| sum + r.units }
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
    Logger.info "Task #{number} waiting"
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
  
  def initial_claim_for(type)
    initial_claim.detect { |i| i.resource_type == type }.units
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
    safe = safe? ? "SAFE" : "UNSAFE"
    if aborted?
      "Task #{number} aborted"
    else
      "Task #{number} #{safe} #{allocation.inspect}"
    end
  end
  protected

  def initiates
    @initiates ||= activities.select { |a| a.name == TaskActivity::INITIATE }.sort_by { |a| a.resource_type }
  end
  
  def requests
    @requests ||= activities.select { |a| a.name == TaskActivity::REQUEST }.sort_by { |a| a.resource_type }
  end
end