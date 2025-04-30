class Admin::PendingCrawlSourcesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_pending_crawl_sources, only: [ :update ]

  def index
    @crawl_sources = CrawlSource.where(approval_status: :pending)
  end

  def update
    if params[:approval_status].present?
      @crawl_source.update(approval_status: params[:approval_status])
      @crawl_source.crawl_data_temporaries.update_all(data_status: params[:approval_status])
      redirect_to admin_pending_crawl_sources_path, notice: "Source has been #{params[:approval_status]}"
    else
      redirect_to admin_pending_crawl_sources_path, alert: "Invalid approval status"
    end
  end

  private

    def set_pending_crawl_sources
      @crawl_source = CrawlSource.find(params[:id])
    end

    def pending_crawl_sources_params
      params.require(:crawl_source).permit(:approval_status)
    end
end
