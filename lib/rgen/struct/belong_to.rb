class Rgen::Struct::BelongTo
  attr_reader :model, :optional, :plural_inverse

  def initialize(model, optional: true,
                        plural_inverse: false)
    @model = model
    @optional = !!optional
    @plural_inverse = !!plural_inverse
  end
end
