require 'securerandom'

class CreateClient
  include Interactor

  def call
    secret = SecureRandom.uuid
    client = Client.new(secret: secret)

    if client.save
      context.credentials = { client_id: client.id, secret: secret }
    else
      context.fail!(error: client.errors.full_messages)
    end
  end
end
