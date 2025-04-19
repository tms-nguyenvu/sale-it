Rails.application.routes.draw do
  devise_for :users, skip: [:registrations]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")

  resources :companies do
    resources :contacts, shallow: true
  end

  resources :leads do
    resources :emails, shallow: true
    resources :tasks, shallow: true
    resources :proposals, shallow: true
  end

  # User management (admin only)
  namespace :admin do
    resources :users
  end

  # Dashboard
  get 'dashboard', to: 'dashboard#index'

  root "dashboard#index"
end
