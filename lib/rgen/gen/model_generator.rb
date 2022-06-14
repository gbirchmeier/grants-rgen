require 'active_support/inflector'

class Rgen::Gen::ModelGenerator

  def generate_file(model, destination)
    fullpath = File.join(destination, model.name.underscore + '.rb')
    File.write(fullpath, generate_file_content(model))
    fullpath
  end

  private

  def generate_file_content(model)
    belongs_str = generate_belongs_string(model)
    enums_str = generate_enum_definitions_string(model)
    validations_str = generate_validations_string(model)

    rva = []
    rva << '# frozen_string_literal: true'
    rva << "class #{model.name} < ApplicationRecord"

    unless belongs_str.strip.empty?
      rva << belongs_str
      rva << ''
    end

    unless enums_str.strip.empty?
      rva << enums_str
      rva << ''
    end

    unless validations_str.strip.empty?
      rva << validations_str
      rva << 'end'
    end

    rva.join("\n") + "\n"
  end

  def generate_enum_definitions_string(model)
    enums = {}
    model.attributes.select { |att| !!att.enums }.each do |att|
      enums[att.name] = att.enums
    end
    rva = []
    enums.each do |name, enum_values|
      rva << "  assignable_values_for :#{name} do"
      rva << '    ['
      enum_values.each do |ev|
        rva << "      #{ev},"
      end
      rva << '    ]'
      rva << '  end'
    end
    rva.join("\n")
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

  def generate_validation_for_attribute(model_name, att)
    return nil unless att.presence || att.unique
    rv = nil

    if att.datatype == 'boolean'
      if att.presence
        rv = "  validates :#{att.name}, inclusion: { in: [true, false] }"
      else
        rv = "  validates :#{att.name}, inclusion: { in: [true, false, nil] }"
      end
    elsif att.datatype == 'enum'
      if att.presence
        rv = "  validates :#{att.name}, inclusion: { in: #{model_name}.#{att.name.pluralize.underscore}.keys }"
      else
        rv = "  validates :#{att.name}, inclusion: { in: #{model_name}.#{att.name.pluralize.underscore}.keys + [nil] }"
      end
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
      val = generate_validation_for_attribute(model.name, att)
      rva << val unless val.nil?
    end
    rva.join("\n")
  end
end
