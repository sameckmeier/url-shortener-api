class Api::V1::ClientsController < ApplicationController
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
