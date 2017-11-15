require 'api_version_constraint'

Rails.application.routes.draw do
  get '/', to: 'application#index'

  api_opts = {
    defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/'
  }
  namespace :api, api_opts do
    v1_opts = {
      path: '/',
      constraints: ApiVersionConstraint.new(version: 1, default: true)
    }
    namespace :v1, v1_opts do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations'
      }

      resources :users, only: %i[index show create update destroy]
      resources :sessions, only: %i[create destroy]
      resources :ticket_types, only: %i[index show create update destroy]
      resources :tickets, only: %i[index show create update destroy] do
        resources :ticket_topics,
                  path: 'topics',
                  only: %i[index show create update]
      end
    end
  end
end
