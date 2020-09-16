require 'bcrypt'

class Client < ApplicationRecord
  self.implicit_order_column = :created_at

  has_secure_password :secret

  has_many :urls, dependent: :destroy

  class << self
    # Overrides method defined by Knock gem: https://github.com/nsarno/knock#in-the-entity-model
    def from_token_request(request)
      client_id = request.params['auth'] && request.params['auth']['client_id']
      find_by(id: client_id)
    end
  end
end
