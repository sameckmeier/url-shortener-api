FactoryBot.define do
  factory :shortened_url do
    add_attribute(:sequence) { ShortenedUrl::INITIAL_SEQUENCE_CHAR }
  end
end
