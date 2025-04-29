class Admin::CrawlSourcesController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    def index
    end
end
