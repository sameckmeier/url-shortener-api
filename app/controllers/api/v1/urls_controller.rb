class Api::V1::UrlsController < ApplicationController
  before_action :authenticate_client, except: [:show]

  api :GET, ':shortened_url', 'Redirects to the original url'
  returns code: 302

  def show
    redirect_to url.original
  end

  api :DELETE, 'api/v1/urls/:shortened_url', 'Requires authentication: destroys an url'
  returns code: 204

  def destroy
    result = DestroyUrl.call(url: url(client_id: current_client.id))

    if result.success?
      render status: :no_content
    else
      logger.error(result.error)
      render json: { error: 'There was an issue destroying your url' }, status: :unprocessable_entity
    end
  end

  api :POST, 'api/v1/urls', 'Requires authentication: creates an url'
  param :url, Hash, required: true do
    param :original, String, required: true, desc: "Original url"
    param :shortened, String, required: false, desc: "Slug to use as shortened url"
  end
  returns code: 201 do
    property :url, Hash, required: true do
      property :id, Numeric, required: true
      property :original, String, required: true, desc: "Original url"
      property :shortened, String, required: true, desc: "Shortened url"
      property :client_id, String, required: true
      property :created_at, String, required: true
      property :updated_at, String, required: true
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
