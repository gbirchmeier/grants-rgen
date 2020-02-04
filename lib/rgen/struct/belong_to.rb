require 'active_support/inflector'

class Rgen::Struct::BelongTo
  attr_reader :model, :optional, :plural_inverse, :name

  def initialize(model, optional: true,
                        plural_inverse: false,
                        name: nil)
    @model = model.underscore
    @optional = !!optional
    @plural_inverse = !!plural_inverse
    @name = name
  end
end
