Rails.application.routes.draw do
  mount API => '/'
  get '/docs' => redirect('/swagger-ui/dist/index.html?url=/swagger_docs')

  mount ActionCable.server => '/cable'
  root to: 'visitors#index'

  get '/chat', to: "chat#chat"
  post '/message', to: "chat#message"
  get '/update_session', to: 'create_password#update_session'
  get '/delete_conversation', to: 'create_password#delete_conversation'


  devise_for :users
  resources :users
end
