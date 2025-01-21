Rails.application.routes.draw do
  # Root route
  root "posts#index"

  # Devise routes
  devise_for :users

  # User routes
  resources :users, only: [:edit, :update], param: :username do
    member do
      get :settings
      patch :update_settings
    end
  end

  # Follow routes
  resources :follows, only: [:create, :update, :index]

  # Post routes
  resources :posts

  # Admin namespace
  namespace :admin do
    resources :users, only: %i[index edit update]
  end

  # Letter Opener for development
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Custom user profile route
  get "/:username", to: "users#show", as: :user_profile, constraints: { username: /[a-zA-Z0-9_]+/ }
end
