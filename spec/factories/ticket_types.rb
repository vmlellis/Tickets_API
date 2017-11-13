FactoryBot.define do
  factory :ticket_type do
    name { Faker::Job.field }
  end
end
