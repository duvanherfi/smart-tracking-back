FactoryBot.define do
  factory :user do
    name { "John" }
    email { "jhon@gmail.com" }
    phone { "1234567890" }
    password { "password" }

    factory :user_with_sessions do
      after(:create) do |user|
        user.sessions.create
      end
    end
  end
end
