require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users, skip: %i[registrations]

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin, path: "/" do
    resources :companies

    resources :potential_companies, only: %i[index]
    resources :decision_maker_companies, only: %i[index]
    resources :predict_ability_companies, only: %i[index]

    resources :leads do
      resources :emails, shallow: true
      resources :tasks, shallow: true
      resources :proposals, shallow: true
    end

    resources :crawl_sources, only: %i[index create destroy update]
    resources :pending_crawl_sources, only: %i[index update]
    resources :history_crawl_sources, only: %i[index]

    get "dashboard", to: "dashboard#index"
  end

  root "admin/dashboard#index"

  mount Sidekiq::Web => "/sidekiq"
end
