require 'api_version_constraint'

Rails.application.routes.draw do

  devise_for :users, only: %i[ sessions ], controller: { sessions: 'api/v1/sessions' }

  namespace :api, defaults: { format: :json }, constraints: { subdomain: 'api' }, path: '/' do
    namespace :v1, path: '/', constraints: ApiVersionConstraint.new(version: 1) do
      resources :users, only: %i[ show create update destroy ]
      resources :sessions, only: %i[ create destroy ]
      resources :tasks, only: %i[ index show create update destroy ]
    end

    namespace :v2, path: '/', constraints: ApiVersionConstraint.new(version: 2, default: true) do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: %i[ show create update destroy ]
      resources :sessions, only: %i[ create destroy ]
      resources :tasks, only: %i[ index show create update destroy ]
    end
  end

end
