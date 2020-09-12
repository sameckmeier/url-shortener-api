require 'rails_helper'

describe 'Api::V1::Clients' do
  describe 'POST clients#create' do
    it 'creates a Client' do
      post '/api/v1/clients', headers: default_headers

      body = JSON.parse(response.body)
      client = Client.find(body['credentials']['client_id'])

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
      expect(client.id).to eq(body['credentials']['client_id'])
    end

    context 'when there is an issue creating a Client' do
      before { allow_any_instance_of(Client).to receive(:save).and_return(false) }

      it 'does not create a Client' do
        post '/api/v1/clients', headers: default_headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
