require 'rails_helper'

describe 'Api::V1::ClientToken' do
  describe 'POST auth_tokens#create' do
    let(:client) { create(:client) }

    it 'creates a client token' do
      post '/api/v1/client_token', params: { auth: { client_id: client.id, secret: client.secret } }, headers: default_headers

      body = JSON.parse(response.body)
      jwt = Knock::AuthToken.new(token: body['jwt']).payload

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
      expect(Client.find(jwt['sub'])).to eq(client)
    end
  end
end
