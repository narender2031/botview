Rails.application.routes.draw do
  mount API => '/'
  get '/docs' => redirect('/swagger-ui/dist/index.html?url=/swagger_docs')

  root to: 'visitors#index'

  get '/chat', to: "chat#index"

  devise_for :users
  resources :users
end
