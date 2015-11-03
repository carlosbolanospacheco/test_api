#require 'api_constraints'

Rails.application.routes.draw do
  match "/404" => "errors#not_found", via: [:get, :post, :patch, :delete]
  match "/500" => "errors#exception", via: [:get, :post, :patch, :delete]
  
#  namespace :api, defaults: { format: :json}, constraints: {subdomain: 'api'}, path: '/' do
#    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
  namespace :api, defaults: { format: :json} do
    namespace :v1 do
      resources :users, only: [:show, :index, :create, :update, :destroy]
      resources :sessions, only: [:create]
      resources :congresses, :events, only: [:show, :index, :create, :update, :destroy]
    end
  end
end
