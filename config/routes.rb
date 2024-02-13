Rails.application.routes.draw do
  get 'sessions/new'
  get '/help', to: "static_pages#help"
  get '/home', to: "static_pages#home"
  get '/', to: "static_pages#home"

  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
  resources :account_activations, only: [:edit]
end
