require 'active_support/inflector'

class Rgen::Gen::ActiveAdminGenerator
  include ActiveSupport::Inflector

  def generate(model)
    generate_file_content(
      model.name,
      generate_permit_params(model),
      generate_index_columns(model),
      generate_show_columns(model),
      generate_form_columns(model))
  end

  private

  def generate_file_content(model_name, permit_params_arr, index_cols_str, show_cols_str, form_cols_str)
    <<TEMPLATE_END
ActiveAdmin.register #{model_name} do
  permit_params #{permit_params_arr.join(', ')}

  config.batch_actions = false

  #config.sort_order = 'name_asc'

  #filter :name
  #filter :some_assoc, collection: proc { SomeAssoc.order(:name) }

  index download_links: false do
    id_column
    # column :assoc_foos, sortable: 'assoc_foos.name'
    # column('Thing') {|thing| thing.some_other_name }
#{index_cols_str}
    actions
  end

  show do |x|
    attributes_table do
      row :id
      # row('Thing') {|thing| thing.some_other_name }
#{show_cols_str}
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      # f.input :not_a_string, as: :string, hint: 'this is a hint'
#{form_cols_str}
    end
    f.actions
  end
end
TEMPLATE_END
  end

  def generate_permit_params(model)
    (model.attributes.collect(&:name) + model.belong_tos.collect(&:model)).collect {|x| ":#{x}"}
  end

  def generate_index_columns(model)
    rva = []
    rva += model.attributes.collect {|att| "    column :#{att.name}"}
    rva += model.belong_tos.collect {|bt| "    column :#{bt.model}"}
    rva.join "\n"
  end

  def generate_show_columns(model)
    rva = []
    rva += model.attributes.collect {|att| "      row :#{att.name}"}
    rva += model.belong_tos.collect {|bt| "      row :#{bt.model}"}
    rva.join "\n"
  end

  def generate_form_columns(model)
    rva = []
    rva += model.attributes.collect {|att| "      f.input :#{att.name}"}
    rva += model.belong_tos.collect {|bt| "      f.input :#{bt.model}"}
    rva.join "\n"
  end
end
