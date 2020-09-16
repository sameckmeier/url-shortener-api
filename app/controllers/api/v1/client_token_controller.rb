class Api::V1::ClientTokenController < Knock::AuthTokenController
  private

  # Below methods override ones defined by Knock gem: https://github.com/nsarno/knock/blob/master/app/controllers/knock/auth_token_controller.rb
  def authenticate
    raise Knock.not_found_exception_class unless entity.present? && entity.authenticate_secret(auth_params[:secret])
  end

  def auth_params
    params.require(:auth).permit(:client_id, :secret)
  end
end
