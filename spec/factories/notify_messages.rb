FactoryBot.define do
  factory :notify_message do
    message { Faker::Lorem.paragraph }
  end
end
