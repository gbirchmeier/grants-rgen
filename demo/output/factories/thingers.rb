FactoryBot.define do
  factory :thinger do

    association :product_line, factory: :product_line
  end
end
