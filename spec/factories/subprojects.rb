FactoryBot.define do
  factory :subproject do
    sequence(:name) { |n| "Subproject #{n}" }
    project
  end
end
