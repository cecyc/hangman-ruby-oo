class Input
  attr_accessor :value

  def initialize(value = nil, &validator)
    @value = value
    @validator = validator
  end

  def valid?
    @validator.call(@value)
  end
end
