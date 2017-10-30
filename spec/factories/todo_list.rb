FactoryBot.define do
  factory :todo_list do
    user { create :user }
    position { FactoryBot.next_position_for user }
    sequence(:title) {|i| "List #{i}" }
    sequence(:description) {|i| "My Test List #{i}" }
  end
end
