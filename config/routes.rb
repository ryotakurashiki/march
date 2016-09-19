Rails.application.routes.draw do

  root to: "statics#welcome"

  devise_for :users, controllers: {
  	confirmations: 'confirmations',
  	omniauth_callbacks: "omniauth_callbacks"
  }
  scope module: :user do
    get '/tutorial', to: "statics#tutorial"
    get '/tutorial/:janru', to: "statics#tutorial_janru", as: "tutorial_janru"
    post '/tutorial/finish', to: "statics#tutorial_finish", as: "tutorial_finish"
    get '/timeline/future', to: "statics#timeline_future"
    get '/timeline/past', to: "statics#timeline_past"
    get '/profile', to: "statics#profile"
    resource :favorite_artists
    resource :favorite_prefectures
  end

  get '/:username', to: 'users#show', as: 'user_open'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :admins, only: [:sessions]
  namespace :admin do
    resources :deactive_concerts
    resources :concerts
    resources :artists

    resources :medium_artist_relations
    resources :artist_relations
    resources :media
    resources :appearance_artists
  end

end
