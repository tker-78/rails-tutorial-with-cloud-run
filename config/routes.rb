Rails.application.routes.draw do
  get '/help', to: "static_pages#help"
  get '/home', to: "static_pages#home"
  get '/', to: "static_pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users
end
