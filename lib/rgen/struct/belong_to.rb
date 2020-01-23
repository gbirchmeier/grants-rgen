require 'active_support/inflector'

class Rgen::Struct::BelongTo
  attr_reader :model, :optional, :plural_inverse

  def initialize(model, optional: true,
                        plural_inverse: false)
    @model = model.underscore
    @optional = !!optional
    @plural_inverse = !!plural_inverse
  end
end
