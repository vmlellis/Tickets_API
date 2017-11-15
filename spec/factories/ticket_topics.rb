FactoryBot.define do
  factory :ticket_topic do
    description { Faker::HitchhikersGuideToTheGalaxy.quote }
    user
    ticket
  end
end
