require 'rails_helper'

describe 'Api::V1::Urls' do
  let(:client) { create(:client) }
  let(:headers) { authorization_headers(client) }
  let(:url) { create(:url, client: client) }
  let(:existing_url_path) { "/#{url.shortened}" }
  let(:nonexisting_url_path) { '/does-not-exist' }

  before { create(:shortened_url) }

  describe 'DELETE urls#destroy' do
    let(:url_route) { "/api/v1/urls" }
    let(:existing_url_route) { "#{url_route}#{existing_url_path}" }
    let(:nonexisting_url_route) { "#{url_route}#{nonexisting_url_path}" }

    it 'destroys an Url' do
      delete existing_url_route, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    context 'when Url does not exist' do
      it 'does not destroy an Url' do
        delete nonexisting_url_route, headers: headers

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when destroying an Url fails' do
      before do
        allow_any_instance_of(Url).to receive(:destroy).and_return(false)
        create(:url, client: client)
      end

      it 'does not destroy an Url' do
        delete existing_url_route, headers: headers

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when current client does not own url' do
      let!(:url) { create(:url) }

      it 'does not destroy an Url' do
        delete existing_url_route, headers: headers

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST urls#create' do
    it 'creates an Url' do
      post '/api/v1/urls', params: { url: { original: 'http://test.com' } }, headers: headers

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response).to have_http_status(:created)
    end

    context 'when creating an Url fails' do
      it 'does not create an Url' do
        post '/api/v1/urls', params: { url: { original: '' } }, headers: headers

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET urls#show' do
    it 'redirects to url#original' do
      get existing_url_path, headers: default_headers

      expect(response).to redirect_to(url.original)
    end

    context 'when Url does not exist' do
      it 'does not redirect to url#original' do
        get nonexisting_url_path, headers: default_headers

        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
