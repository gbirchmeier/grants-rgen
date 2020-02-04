require 'active_support/inflector'

class Rgen::Gen::ModelGenerator

  def generate(model)
    generate_file_content(
      model.name,
      generate_belongs_string(model),
      generate_validations_string(model))
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
    rv = ''
    if model.name
      rv << "  belongs_to :#{belong.name}, "
      rv << "class_name: '#{belong.model.camelize}', "
    else
      rv << "  belongs_to :#{belong.model.underscore}, "
    end
    rv << "inverse_of: :#{belong.plural_inverse ? model.name.underscore.pluralize : model.name.underscore}, "
    rv << "optional: #{belong.optional}"
    rv
  end

  def generate_belongs_string(model)
    rva = []
    model.belong_tos.each do |b|
      rva << generate_single_belongs(b, model)
    end
    rva.join("\n")
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
    rva = []
    model.attributes.each do |att|
      val = generate_validation_for_attribute(att)
      rva << val unless val.nil?
    end
    rva.join("\n")
  end
end
