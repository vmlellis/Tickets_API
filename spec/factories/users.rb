FactoryBot.define do
  factory :user do
    name 'User'
    email 'email@email.com'
    password '123456'
    password_confirmation '123456'
    role 'customer'
  end

  factory :admin do
    name 'User'
    email 'email@email.com'
    password '123456'
    password_confirmation '123456'
    role 'admin'
  end
end
