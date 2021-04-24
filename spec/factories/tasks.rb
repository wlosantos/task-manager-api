FactoryBot.define do
  factory :task do
    title { "MyString" }
    description { "MyText" }
    done { false }
    deadline { "2021-04-24 17:14:17" }
    user { nil }
  end
end
