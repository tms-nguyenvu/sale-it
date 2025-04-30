class Admin::HistoryCrawlSourcesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!

  def index
    @crawl_sources = CrawlSource.all
  end
end
