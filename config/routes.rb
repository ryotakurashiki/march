Rails.application.routes.draw do
  root to: "statics#welcome"

  resources :deactive_concerts
  resources :medium_artist_relations
  resources :prefectures
  resources :artist_relations
  resources :media
  resources :appearance_artists
  resources :artists
  resources :concerts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
