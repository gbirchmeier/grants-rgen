require 'active_support/inflector'

class Rgen::Gen::MigrationCommandGenerator

  def generate_stdout(model)
    params = build_params(model)
    a = ['Migration command:']
    a << "  > rails generate migration Create#{model.name.pluralize} #{params.join(' ')} --timestamps"
    a << "  NOTE: 'default' and 'null' cannot be set via the command line,"
    a << "        so don't forget to edit the migration!"
    a << '' << ''
    a.join("\n")
  end

  private

  def build_att(att)
    datatype = case att.datatype
    when 'enum' then 'string'
    else att.datatype
    end

    "#{att.name}:#{datatype}"

    # May be relevant to future improvements
    # https://edgeguides.rubyonrails.org/active_record_migrations.html#passing-modifiers
    # https://edgeguides.rubyonrails.org/active_record_migrations.html#column-modifiers
  end

  def build_bt(bt)
    "#{bt.model}:references"
  end

  def build_params(model)
    rva = []
    model.attributes.each do |att|
      rva << build_att(att)
    end
    model.belong_tos.each do |bt|
      rva << build_bt(bt)
    end
    rva
  end
end

