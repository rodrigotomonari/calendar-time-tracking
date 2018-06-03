FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    client
  end
end
