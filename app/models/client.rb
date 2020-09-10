class Client < ApplicationRecord
  self.implicit_order_column = :created_at

  has_secure_password :secret

  has_many :urls, dependent: :destroy
end
