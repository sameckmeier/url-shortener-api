Rails.application.routes.draw do
  apipie
  get '/:shortened_url', to: 'api/v1/urls#show'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      delete '/urls/:shortened_url', to: 'urls#destroy'
      
      resources :urls, only: [:create]
      resources :client_token, only: [:create]
      resources :clients, only: [:create]
    end
  end
end
