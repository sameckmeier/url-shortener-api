class Api::V1::UrlsController < ApplicationController
  before_action :authenticate_client, except: [:show]

  def show
    redirect_to url.original
  end

  def destroy
    result = DestroyUrl.call(url: url(client_id: current_client.id))

    if result.success?
      render status: :no_content
    else
      logger.error(result.error)
      render json: { error: 'There was an issue destroying your url' }, status: :unprocessable_entity
    end
  end

  def create
    result = CreateUrl.call(url_params: url_params, client: current_client)

    if result.success?
      render json: { url: result.url }, status: :created
    else
      logger.error(result.error)
      render json: { error: 'There was an issue creating your url' }, status: :unprocessable_entity
    end
  end

  private

  def url_params
    params.require(:url).permit(:original, :shortened)
  end

  def url(args = {})
    @url ||= Url.find_by({ shortened: params[:shortened_url] }.merge(args))
    raise ActiveRecord::RecordNotFound if @url.blank?

    @url
  end
end
