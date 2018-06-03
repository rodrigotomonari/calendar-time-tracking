FactoryBot.define do
  factory :task do
    started_at { Faker::Time.between(DateTime.now - 10, DateTime.now + 10) }
    ended_at { started_at + rand(5).hours }
    user
    subproject_phase
  end
end
