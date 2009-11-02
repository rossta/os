class Resource
  attr_reader :total_units, :units, :resource_type

  def initialize(units, resource_type = nil)
    @units = units
    @total_units = units
    @resource_type = resource_type
  end

  def request(units)
    raise "Request exceeds available" if units > @units
    @units -= units
    units
  end

  def replenish(units)
    raise "Release exceeds total" if total_units < @units + units
    @units += units
    @units
  end
end