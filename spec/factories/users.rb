FactoryBot.define do
  factory :user do
    name 'User'
    email Faker::Internet.email
    password '123456'
    password_confirmation '123456'
    role 'customer'
  end

  factory :admin, class: User do
    name 'User'
    email Faker::Internet.email
    password '123456'
    password_confirmation '123456'
    role 'admin'
  end
end
