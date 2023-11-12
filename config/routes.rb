Rails.application.routes.draw do
  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unprocessable_entity'
  get '/500', to: 'errors#internal_server_error'

  namespace :admin do
    resources :schedules, only: %i[index create] do
      get :teacher_info, on: :collection
    end
  end

  root 'pages#home'
end
