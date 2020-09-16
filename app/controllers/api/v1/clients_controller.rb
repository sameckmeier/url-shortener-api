class Api::V1::ClientsController < ApplicationController
  api :POST, 'api/v1/clients', 'Creates a client id and secret for client auth'
  returns code: 201 do
    property :credentials, Hash, required: true do
      property :client_id, String, required: true
      property :secret, String, required: true
    end
  end

  def create
    result = CreateClient.call

    if result.success?
      render json: { credentials: result.credentials }, status: :created
    else
      logger.error(result.error)
      render json: { error: 'There was an issue creating your url' }, status: :unprocessable_entity
    end
  end
end
