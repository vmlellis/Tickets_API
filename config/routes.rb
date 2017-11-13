require 'api_version_constraint'

Rails.application.routes.draw do
  get '/', to: 'application#index'
  post '/sign_in', to: 'sessions#create'

  # resources :users, except: %i[new edit]

  namespace :api,
            defaults: { format: :json },
            constraints: { subdomain: 'api' },
            path: '/' do
    namespace :v1,
              path: '/',
              constraints: ApiVersionConstraint.new(
                version: 1, default: true
              ) do
      resources :users, only: %i[show create update destroy]
    end
  end
end
