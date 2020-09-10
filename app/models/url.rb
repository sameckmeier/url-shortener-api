class Url < ApplicationRecord
  belongs_to :client

  validates :original, :shortened, presence: true
  validates :shortened, uniqueness: true
end
