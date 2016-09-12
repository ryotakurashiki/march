Rails.application.routes.draw do
  devise_for :admins, only: [:sessions]
  namespace :admin do
    resources :deactive_concerts
    resources :concerts
    resources :artists
  end

  root to: "timelines#timeline"

  devise_for :users, controllers: {
  	confirmations: 'confirmations',
  	omniauth_callbacks: "omniauth_callbacks"
  }
  scope module: :user do
    resource :concerts
  	resource :artists
  	resource :prefectures
  end

  get '/:username', to: 'users#show', as: 'user_open'

  resources :medium_artist_relations
  resources :artist_relations
  resources :media
  resources :appearance_artists
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
