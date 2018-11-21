Rails.application.routes.draw do
  mount API => '/'
  get '/docs' => redirect('/swagger-ui/dist/index.html?url=/swagger_docs')

  mount ActionCable.server => '/cable'
  root to: 'visitors#index'

  get '/chat', to: "chat#index"
  post '/message', to: "chat#message"

  devise_for :users
  resources :users
end
