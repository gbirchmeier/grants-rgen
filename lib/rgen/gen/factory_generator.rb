require 'active_support/inflector'

class Rgen::Gen::FactoryGenerator

  def generate(model)
    generate_file_content(
      model.name,
      generate_default_values_string_from_attributes(model),
      generate_default_values_string_from_belong_tos(model))
  end

  private

  def generate_file_content(model_name, attributes_str, belong_tos_str)
    <<TEMPLATE_END
FactoryBot.define do
  factory :#{model_name.underscore} do
#{attributes_str}
#{belong_tos_str}
  end
end
TEMPLATE_END
  end

  def generate_for_att(att)
    return nil unless att.presence
    case att.datatype
      when 'string'
        if(att.factory_sequence)
          return "    sequence(:#{att.name}) {|n| \"#{att.name}-\#{n}\"}"
        else
          return "    #{att.name} { 'foo' }"
        end 
      when 'integer'
        if(att.factory_sequence)
          return "    sequence(:#{att.name}) {|n| n}"
        else
          return "    #{att.name} { 123 }"
        end 
      when 'boolean'
        return "    #{att.name} { false }"
      when 'decimal'
        if(att.factory_sequence)
          return "    sequence(:#{att.name}) {|n| n + .99}"
        else
          return "    #{att.name} { 123.4 }"
        end 
      else
        raise "unsupported type '#{att.datatype}' (#{model_name}.#{att.name})"
    end
  end

  def generate_default_values_string_from_attributes(model)
    rva = []
    model.attributes.each do |att|
      x = generate_for_att(att)
      rva << x unless x.nil?
    end
    rva.join("\n")
  end

  def generate_for_belong_to(bt)
    return nil if bt.optional
    if bt.name
      "    association :#{bt.name}, factory: :#{bt.model}"
    else
      "    #{bt.model} { FactoryBot.create(:#{bt.model}) }"
    end
  end

  def generate_default_values_string_from_belong_tos(model)
    rva = []
    model.belong_tos.each do |bt|
      x = generate_for_belong_to(bt)
      rva << x unless x.nil?
    end
    rva.join("\n")
  end
end

