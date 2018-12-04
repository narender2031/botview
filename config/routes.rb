Rails.application.routes.draw do
  mount API => '/'
  get '/docs' => redirect('/swagger-ui/dist/index.html?url=/swagger_docs')

  mount ActionCable.server => '/cable'
  root to: 'visitors#index'

  get '/chat', to: "chat#index"
  post '/message', to: "chat#message"
  get '/password', to: 'create_password#index'
  patch '/create_password', to: 'create_password#create'
  get '/update_session', to: 'create_password#update_session'
  get '/delete_conversation', to: 'create_password#delete_conversation'


  devise_for :users
  resources :users
end
