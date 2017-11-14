FactoryBot.define do
  factory :ticket do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    association :created_by, factory: :user, role: 'customer'
    created_at { Faker::Time.backward(14, :evening) }
    association :agent, factory: :user, role: 'agent'
    association :ticket_type, factory: :ticket_type
  end
end
