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
    get '/tutorial', to: "tutorials#top"
    get '/tutorial/select_janru', to: "tutorials#select_janru"
    get '/tutorial/select_artist/:janru', to: "tutorials#select_artist", as: "tutorial_select_artist"
    get '/tutorial/select_concert', to: "tutorials#select_concert", as: "tutorial_select_concert_first"
    get '/tutorial/select_concert/:artist_id', to: "tutorials#select_concert", as: "tutorial_select_concert"
    post '/tutorial/finish', to: "tutorials#finish"
    get '/timeline/future', to: "timelines#future"
    get '/timeline/past', to: "timelines#past"
    get '/account', to: "statics#account"
    put '/account', to: "statics#update"
    get '/search', to: "statics#search"
    post '/search/filter', to: "statics#search_filter"
    resource :favorite_artists, only: [:create, :destroy, :show]
    resource :favorite_prefectures, only: [:create, :destroy, :show]
    resource :user_concert_joinings, only: [:create]
    resources :concerts, only: [:create, :new, :update, :edit, :index]
    resource :artists, only: [:create]
    post 'concerts/filter', to: "concerts#filter"
    post 'concerts/check_duplicate', to: "concerts#check_duplicate"
    post 'concerts/add_appearance_artist', to: "concerts#add_appearance_artist"
  end

  get '/:username/joined', to: 'users#joined', as: 'user_joined'
  get '/:username/joining', to: 'users#joining', as: 'user_joining'
  get '/:username/favorite', to: 'users#favorite', as: 'user_favorite'
  post '/appearance_artists/sort', to: 'appearance_artists#sort'
  resources :artists, only: [:show] do
    resource :concerts, only: [:show] do
      post '/filter', to: 'concerts#filter'
    end
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
