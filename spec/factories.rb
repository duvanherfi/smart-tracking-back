FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "email#{n}@gmail.com" }
    sequence(:phone) { |n| "#{n}" * 10 }
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
    area_geojson { {
      "coordinates": [
        [
          [
            98.67039510744497,
            3.598934100831031
          ],
          [
            98.67039510744497,
            3.5961691121116393
          ],
          [
            98.673092328453,
            3.5961691121116393
          ],
          [
            98.673092328453,
            3.598934100831031
          ],
          [
            98.67039510744497,
            3.598934100831031
          ]
        ]
      ],
      "type": "Polygon"
    } }
    is_enabled { true }
    association :user
  end

  factory :vehicle do
    external_id { '1234' }
    association :user
  end

  factory :notification do
    sequence(:name) { |n| "Notification #{n}" }
    is_enabled { true }
    association :user
  end
end
