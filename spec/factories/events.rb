FactoryBot.define do
  factory :event do
    association :user

    title { 'Вовсе не тест' }
    description { 'Самый настоящий ивент' }
    address { 'Казань, улица Баумана' }
    datetime { Time.zone.parse('09.10.2021, 13:20') }
  end
end