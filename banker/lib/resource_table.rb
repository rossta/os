class ResourceTable
  
  def self.instance
    @@instance
  end
  
  def self.build(resources)
    @@instance = ResourceTable.new(resources)
  end
  
  def self.find(resource_type)
    instance.find(resource_type)
  end
  
  def self.resources
    instance.resources
  end
  
  def self.replenish(allocation)
    instance.allocations << allocation
  end
  
  def self.reallocate!
    instance.reallocate!
  end
  
  def self.reset!
    instance.reset!
  end
  
  def self.available_units(resource_type)
    find(resource_type).units
  end
  
  def self.status
    "Resources(#{resources.map{|r|r.units}.join(", ")})"
  end

  attr_accessor :resources, :allocations
  def initialize(resources)
    @resources = resources
    @allocations = []
  end
  
  def reallocate!
    allocations.each do |allocation|
      allocation.each do |type, units|
        if resource = find(type)
          resource.replenish(units)
        end
      end
    end
    self.allocations = []
  end
  
  def find(resource_type)
    resources.detect { |r| r.resource_type == resource_type }
  end
  
  def reset!
    resources.each { |r| r.reset! }
  end
end