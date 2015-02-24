FactoryGirl.define do
  factory :sector do
    sequence(:name) { |n| "Sector#{n}" }
    industry
  end
end
