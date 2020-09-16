class Api::V1::ClientTokenController < Knock::AuthTokenController
  api :POST, 'api/v1/client_token', 'Generates a JWT'
  param :auth, Hash, required: true do
    param :client_id, String, required: true
    param :secret, String, required: true
  end
  returns code: 201 do
    property :jwt, String
  end

  private

  # Below methods override ones defined by Knock gem: https://github.com/nsarno/knock/blob/master/app/controllers/knock/auth_token_controller.rb
  def authenticate
    raise Knock.not_found_exception_class unless entity.present? && entity.authenticate_secret(auth_params[:secret])
  end

  def auth_params
    params.require(:auth).permit(:client_id, :secret)
  end
end
