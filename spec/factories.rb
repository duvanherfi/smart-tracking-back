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

  factory :geo_fence do
    name { "Default GeoFence" }
    description { "Default description" }
    lat { "3.14" }
    lon { "-7.2" }
    area_geojson { "{}" }
    centroid_geojson { "{}" }
    is_enabled { true }
    association :user
  end
end
