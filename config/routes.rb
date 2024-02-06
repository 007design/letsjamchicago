Rails.application.routes.draw do
  # get 'users/*path', to: 'letsjam#index'
  # get 'rails/*path', to: 'letsjam#index'

  devise_scope :user do
    post 'signup', to: 'users/registrations#create'
    post 'signin', to: 'users/sessions#create', as: :user_session
    delete 'signout', to: 'users/sessions#destroy'
    patch 'api/v1/users', to: 'users/registrations#update'
    delete 'api/v1/users', to: 'users/registrations#destroy'
    post 'forgot', to: 'users/passwords#create'
    get '/confirm/:confirmation_token', to: 'users/confirmations#show', as: :confirm_user
    get 'reset/:reset_password_token', to: 'users/passwords#edit'
    put 'reset', to: 'users/passwords#update'
  end

  devise_for :users, :controllers => {
    :sessions => 'devise/sessions', 
    :registrations => 'devise/registrations',
    :passwords => 'devise/passwords',
    :confirmations => 'devise/confirmations'
  }

  # devise_for :users, skip: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post 'contact', to: 'letsjam#contact'
  get 'api/v1/users/nearby', to: 'api/v1/users#nearby'

  # Defines the root path route ("/")
  root "letsjam#index"

  namespace :api do
    namespace :v1 do
      resources :users do
        get 'attending', on: :member
      end
      resources :events do
        get 'attend', on: :member
        delete 'decline', on: :member
        post 'invite', on: :member
      end
    end
  end

  get '*path' => 'letsjam#index'
end
