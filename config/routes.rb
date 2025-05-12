require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations]

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin, path: "/" do
    resources :companies

    # Crawl sources
    resources :crawl_sources, only: %i[index create destroy update]
    resources :list_sources, only: %i[index update]
    resources :crawl_data_temporaries, only: %i[update]
    resources :history_crawl_sources, only: %i[index]

    get "dashboard", to: "dashboard#index"

    # Lead generation
    resources :potential_companies, only: %i[index]
    resources :decision_maker_companies, only: %i[index]
    resources :predict_ability_companies, only: %i[index]

    # Email outreach
    resources :emails
    resources :email_optimizations, only: %i[create]
    resources :email_replies
    get "email_tracking", to: "email_tracking#track_click"
  end

  root "admin/dashboard#index"
  mount Sidekiq::Web => "/sidekiq"
end
