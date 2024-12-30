require 'rswag/ui'
require 'rswag/api'
Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'urls#new'
  resources :urls, only: [:create]
  get '/:short_url', to: 'urls#redirect'

  namespace :api do
    namespace :v1 do
      post '/create_shorten_url', to: 'urls#create', as: 'shorten_url'
    end
  end


end
