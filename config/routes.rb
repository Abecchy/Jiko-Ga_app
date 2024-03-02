Rails.application.routes.draw do
  root "static_pages#top"
  resources :users
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    get "likes", on: :collection
  end
  resources :likes, only: %i[create destroy]

  get "login", to: "user_sessions#new"
	post "login", to: "user_sessions#create"
	delete "logout", to: "user_sessions#destroy"
end
