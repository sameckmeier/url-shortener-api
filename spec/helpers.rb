module Spec
  module Helpers
    def default_headers
      { "ACCEPT" => "application/json" }
    end

    def authorization_headers(client)
      headers = default_headers
      token = Knock::AuthToken.new(payload: { sub: client.id }).token
      headers['Authorization'] = "Bearer #{token}"

      headers
    end
  end
end
