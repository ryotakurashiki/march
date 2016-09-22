Rails.application.routes.draw do

  root to: "statics#welcome"

  # お問い合わせ
  get 'inquiry' => 'inquiry#index'              # 入力画面
  post 'inquiry/thanks' => 'inquiry#thanks'     # 送信完了画面

  devise_for :users, controllers: {
  	confirmations: 'confirmations',
  	omniauth_callbacks: "omniauth_callbacks"
  }
  scope module: :user do
    get '/tutorial', to: "tutorials#select_janru"
    get '/tutorial/:janru', to: "tutorials#select_artist", as: "tutorial_select_artist"
    post '/tutorial/finish', to: "tutorials#finish"
    get '/timeline/future', to: "timelines#future"
    get '/timeline/past', to: "timelines#past"
    get '/profile', to: "statics#profile"
    get '/search', to: "statics#search"
    resource :favorite_artists, only: [:create, :destroy, :show]
    resource :favorite_prefectures
    resource :user_concert_joinings, only: [:create]
  end

  #get '/:username', to: 'users#show', as: 'user_open'
  get '/:username/joined', to: 'users#joined', as: 'user_joined'
  get '/:username/joining', to: 'users#joining', as: 'user_joining'
  resources :artists, only: [:show] do
    resource :concerts, only: [:show]
  end
  resources :concerts, only: [:show] do
    resource :tickets, only: [:show]
  end

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
