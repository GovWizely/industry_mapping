FactoryGirl.define do
  factory :industry do
    sequence(:name) { |n| "Industry#{n}" }
  end
end
