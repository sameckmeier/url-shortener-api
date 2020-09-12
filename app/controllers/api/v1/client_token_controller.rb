class Api::V1::ClientTokenController < Knock::AuthTokenController
  private

  def authenticate
    raise Knock.not_found_exception_class unless entity.present? && entity.authenticate_secret(auth_params[:secret])
  end

  def auth_params
    params.require(:auth).permit(:client_id, :secret)
  end
end
