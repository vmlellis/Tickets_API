require 'api_version_constraint'

Rails.application.routes.draw do
  get '/', to: 'application#index'

  devise_for  :users,
              only: %i[sessions],
              controllers: { sessions: 'api/v1/sessions' }

  namespace :api,
            defaults: { format: :json },
            constraints: { subdomain: 'api' },
            path: '/' do
    namespace :v1,
              path: '/',
              constraints: ApiVersionConstraint.new(
                version: 1, default: true
              ) do
      resources :users, only: %i[index show create update destroy] do
        collection do
          get :current, to: 'user#show'
          put :current, to: 'user#update'
        end
      end
      resources :sessions, only: %i[create destroy]
      resources :ticket_types, only: %i[index show create update destroy]
      resources :tickets, only: %i[index show create]
    end
  end
end
