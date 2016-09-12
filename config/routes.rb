Rails.application.routes.draw do
  devise_for :users
  devise_for :admins, only: [:sessions]
  namespace :admin do
    resources :deactive_concerts
  end

  #devise_for :admins, :controllers => {
  # :registrations => 'admins/registrations',
  # :sessions => 'admins/sessions'
  #}
  root to: "statics#welcome"
  resources :medium_artist_relations
  resources :prefectures
  resources :artist_relations
  resources :media
  resources :appearance_artists
  resources :artists
  resources :concerts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
