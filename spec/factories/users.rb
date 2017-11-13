FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password '123456'
    password_confirmation '123456'
    role 'customer'
  end

  factory :admin, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password '123456'
    password_confirmation '123456'
    role 'admin'
    auth_token '123xyz@ADMIN'
  end

  factory :agent, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password '123456'
    password_confirmation '123456'
    role 'agent'
    auth_token '123xyz@AGENT'
  end

  factory :customer, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password '123456'
    password_confirmation '123456'
    role 'customer'
    auth_token '123xyz@CUSTOMER'
  end
end
