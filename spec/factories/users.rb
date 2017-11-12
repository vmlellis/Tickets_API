FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password '123456'
    password_confirmation
  end

  factory :admin do
    email { Faker::Internet.email }
    password '123456'
    password_confirmation
  end

  factory :agent do
    email ''
  end

  factory :customer do
    email ''
  end
end
