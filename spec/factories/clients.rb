require 'securerandom'

FactoryBot.define do
  factory :client do
    secret { SecureRandom.uuid }
  end
end
