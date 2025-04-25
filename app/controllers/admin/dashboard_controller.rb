# app/controllers/dashboard/dashboard_controller.rb
module Admin
  class DashboardController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    def index
    end
  end
end
