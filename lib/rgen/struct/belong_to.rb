require 'active_support/inflector'

class Rgen::Struct::BelongTo
  attr_reader :model, :optional, :plural_inverse, :name

  def self.create(name, settings_hash)
    model = settings_hash['model'] || name
    props = settings_hash['properties']&.split(' ') || []
    raise "can't be both optional AND required" if props.include?('optional') && props.include?('required')

    Rgen::Struct::BelongTo.new(model,
      optional: !props.include?('required'),
      plural_inverse: props.include?('inverse_is_plural'),
      name: name)
  rescue => e
    raise #need custom errors
  end

  def initialize(model, optional: true,
                        plural_inverse: false,
                        name: nil)
    @model = model.underscore
    @optional = !!optional
    @plural_inverse = !!plural_inverse
    @name = name
  end
end
