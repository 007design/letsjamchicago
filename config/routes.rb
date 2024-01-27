Rails.application.routes.draw do
  get 'signin', to: 'letsjam#index'

  # devise_for :users, path: '', path_names: {
  #   sign_in: 'signin',
  #   sign_out: 'signout',
  #   registration: 'signup'
  # },
  # controllers: {
  #   sessions: 'users/sessions',
  #   registrations: 'users/registrations'
  # }
  devise_scope :user do
    post 'signup', to: 'users/registrations#create'
    post 'signin', to: 'users/sessions#create', as: :user_session
    delete 'signout', to: 'users/sessions#destroy'
  end
  devise_for :users, skip: :all
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "letsjam#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index]
      resources :events
    end
  end

  get '*path' => 'letsjam#index'
end
