class Rgen::Struct::BelongTo
  attr_reader :model, :optional

  def initialize(model, optional: true)
    @model = model
    @optional = !!optional
  end
end
