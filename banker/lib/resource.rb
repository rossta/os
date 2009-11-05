class Resource
  attr_reader :max, :units, :resource_type

  def initialize(units, resource_type = nil)
    @units = units
    @max = units
    @resource_type = resource_type
  end

  def request(units)
    raise "Request exceeds available" if units > @units
    @units -= units
    units
  end

  def replenish(units)
    raise "Release exceeds total" if max < @units + units
    @units += units
    @units
  end
end