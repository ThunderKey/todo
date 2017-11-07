FactoryBot.define do
  factory :user do
    sequence(:email) {|i| "hans#{i}.muster#{i}@test.ch" }
    sequence(:firstname) {|i| "Hans #{i}" }
    sequence(:lastname) {|i| "Muster #{i}" }
    time_zone 'Berlin'
  end
end
