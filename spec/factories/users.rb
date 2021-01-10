FactoryBot.define do
  # Фабрика, создающая юзеров
  factory :user do
    name { "Zhora_#{rand(789)}" }

    sequence(:email) { |n| "someguy#{n}@examle.com"}

    after(:build) { |user| user.password_confirmation = user.password = "123456" }
  end
end