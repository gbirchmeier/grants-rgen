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
    end

    rva << 'end'
    rva.join("\n") + "\n"
  end

  def generate_enum_definitions_string(model)
    enums = []
    model.attributes.select { |att| !!att.enums }.each do |att|
      enums << att
    end
    enums.collect {|enumX| generate_single_enum_def_string(enumX) }.join("\n")
  end

  def generate_single_enum_def_string(enumX)
    rva = []
    rva << "  assignable_values_for :#{enumX.name}, allow_blank: true do"
    rva << '    ['
    enumX.enums.each do |ev|
      rva << "      '#{ev}',"
    end
    rva << '    ]'
    rva << '  end'
    if enumX.presence
      rva << "  validates :#{enumX.name}, presence: true"
    end
    rva << ''
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

    return if att.datatype == 'enum'

    if att.datatype == 'boolean'
      if att.presence
        rv = "  validates :#{att.name}, inclusion: { in: [true, false] }"
      else
        rv = "  validates :#{att.name}, inclusion: { in: [true, false, nil] }"
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
