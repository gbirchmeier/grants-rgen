require 'active_support/inflector'

class Rgen::Gen::ModelGenerator
  include ActiveSupport::Inflector

  def init()
  end

  def generate(model)
    generate_file_content(
      model.name,
      generate_belongs_string(model),
      generate_validations_string(model)
    )
  end

  private

  def generate_file_content(model_name, belongs_str, validations_str)
    <<TEMPLATE_END
class #{model_name} < ApplicationRecord
#{belongs_str}

#{validations_str}
end
TEMPLATE_END
end

  def generate_single_belongs(belong, model)
    rv = "  belongs_to :#{belong.model.underscore}, "
    rv << "inverse_of: :#{belong.plural_inverse ? model.name.underscore.pluralize : model.name.underscore}, "
    rv << "optional: #{belong.optional}"
    rv
  end

  def generate_belongs_string(model)
    rv = []
    model.belong_tos.each do |b|
      rv << generate_single_belongs(b, model)
    end
    rv.join("\n")
  end

  def generate_validation_for_attribute(att)
    return nil unless att.presence || att.unique
    rv = nil

    if att.datatype=='boolean' && att.presence
      rv = "  validates :#{att.name}, inclusion: { in: [true, false] }"
    else
      rv = "  validates :#{att.name}"
      rv << ", presence: true" if att.presence
      rv << ", uniqueness: true" if att.unique
      rv
    end
    rv
  end

  def generate_validations_string(model)
    rv = []
    model.attributes.each do |att|
      val = generate_validation_for_attribute(att)
      rv << val unless val.nil?
    end
    rv.join("\n")
  end
end
