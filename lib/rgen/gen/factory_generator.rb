require 'active_support/inflector'

class Rgen::Gen::FactoryGenerator

  def generate_file(model, destination)
    fullpath = File.join(destination, model.name.pluralize.underscore + '.rb')
    File.write(fullpath, generate_file_content(model))
    fullpath
  end

  private

  def generate_file_content(model)
    attributes_str = generate_default_values_string_from_attributes(model)
    belong_tos_str = generate_default_values_string_from_belong_tos(model)

    rva = []
    rva << 'FactoryBot.define do'
    rva << "  factory :#{model.name.underscore} do"
    unless attributes_str.strip.empty?
      rva << attributes_str
    end
    unless belong_tos_str.strip.empty?
      rva << belong_tos_str
    end
    rva << '  end'
    rva << 'end'

    rva.join("\n") + "\n"
  end

  def generate_for_att(model_name, att)
    return nil unless att.presence
    case att.datatype
      when 'string'
        if att.factory_sequence
          return "    sequence(:#{att.name}) {|n| \"#{att.name}-\#{n}\" }"
        else
          return "    #{att.name} { 'foo' }"
        end 
      when 'integer'
        if att.factory_sequence
          return "    sequence(:#{att.name}) {|n| n }"
        else
          return "    #{att.name} { 123 }"
        end 
      when 'boolean'
        return "    #{att.name} { false }"
      when 'decimal'
        if att.factory_sequence
          return "    sequence(:#{att.name}) {|n| n + .99 }"
        else
          return "    #{att.name} { 123.4 }"
        end 
      when 'enum'
        return "    #{att.name} { #{model_name}.#{att.name.pluralize.underscore}[:#{att.enums.first.to_s}] }"
      else
        raise "unsupported type '#{att.datatype}' (#{model_name}.#{att.name})"
    end
  end

  def generate_default_values_string_from_attributes(model)
    rva = []
    model.attributes.each do |att|
      x = generate_for_att(model.name, att)
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

