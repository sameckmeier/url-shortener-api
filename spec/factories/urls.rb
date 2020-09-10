FactoryBot.define do
  factory :url do
    original { Faker::Internet.url }
    shortened { Faker::Alphanumeric.alpha(number: 3) }

    client
  end
end
