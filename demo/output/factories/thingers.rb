FactoryBot.define do
  factory :thinger do
    sequence(:name) {|n| "name-#{n}"}
    association :product_line, factory: :product_line
  end
end
