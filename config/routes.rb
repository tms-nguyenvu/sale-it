require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin, path: "/" do
    resources :companies

    resources :potential_companies
    resources :decision_maker_companies
    resources :predict_ability_companies

    resources :leads do
      resources :emails, shallow: true
      resources :tasks, shallow: true
      resources :proposals, shallow: true
    end

    resources :crawl_sources, only: [ :index, :create, :destroy, :update ]
    resources :pending_crawl_sources, only: [ :index, :update ]
    resources :history_crawl_sources, only: [ :index ]
    get "dashboard", to: "dashboard#index"
  end

  root "admin/dashboard#index"

  mount Sidekiq::Web => "/sidekiq"
end
