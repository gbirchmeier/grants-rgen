ActiveAdmin.register thinger do
  permit_params :name, :qty, :weight, :approved, :product_line_id, :managing_owner_id, :manufacturer_id

  config.batch_actions = false

  #config.sort_order = 'name_asc'

  #filter :name
  #filter :some_assoc, collection: proc { SomeAssoc.order(:name) }

  index download_links: false do
    id_column
    # column :assoc_foos, sortable: 'assoc_foos.name'
    # column('Thing') {|thing| thing.some_other_name }
    column :name
    column :qty
    column :weight
    column :approved
    column :product_line
    column :managing_owner
    column :manufacturer
    actions
  end

  show do |x|
    attributes_table do
      row :id
      # row('Thing') {|thing| thing.some_other_name }
      row :name
      row :qty
      row :weight
      row :approved
      row :product_line
      row :managing_owner
      row :manufacturer
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      # f.input :not_a_string, as: :string, hint: 'this is a hint', member_label: :debug_name
      f.input :name
      f.input :qty
      f.input :weight
      f.input :approved
      f.input :product_line
      f.input :managing_owner
      f.input :manufacturer
    end
    f.actions
  end
end
