require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin, path: "/" do
    resources :companies


    # Crawl sources
    resources :crawl_sources, only: [ :index, :create, :destroy, :update ]
    resources :pending_crawl_sources, only: [ :index, :update ]
    resources :history_crawl_sources, only: [ :index ]
    get "dashboard", to: "dashboard#index"

    # Lead generation
    resources :potential_companies, only: [ :index ]
    resources :decision_maker_companies, only: [ :index ]
    resources :predict_ability_companies, only: [ :index ]

    # Email outreach
    resources :emails
  end

  root "admin/dashboard#index"

  mount Sidekiq::Web => "/sidekiq"
end
