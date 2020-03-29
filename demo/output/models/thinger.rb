class thinger < ApplicationRecord
  belongs_to :product_line, class_name: 'ProductLine', inverse_of: :thingers, optional: false
  belongs_to :managing_owner, class_name: 'Owner', inverse_of: :thingers, optional: true
  belongs_to :manufacturer, class_name: 'Manufacturer', inverse_of: :thinger, optional: true

  validates :name, uniqueness: true
end
