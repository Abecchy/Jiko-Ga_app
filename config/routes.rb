Rails.application.routes.draw do
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :posts do
    resources :comments, only: %i[create destroy], shallow: true
    get 'likes', on: :collection
  end
  resources :likes, only: %i[create destroy]
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]

  get 'login', to: 'user_sessions#new'
	post 'login', to: 'user_sessions#create'
	delete 'logout', to: 'user_sessions#destroy'

  get 'terms_of_service', to: 'static_pages#terms_of_service'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'contact_us', to: 'static_pages#contact_us'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
