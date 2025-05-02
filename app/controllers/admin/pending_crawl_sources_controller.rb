class Admin::PendingCrawlSourcesController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :set_pending_crawl_sources, only: [ :update ]

  def index
    @crawl_sources = CrawlSource.where(approval_status: :pending)
  end

  def update
    if params[:approval_status].present?
      if params[:approval_status] == "approved"
        ApproveCrawlSourceJob.perform_later(@crawl_source.id)
        notice = "Approval is being processed in the background."
      else
        @crawl_source.update!(approval_status: params[:approval_status])
        @crawl_source.crawl_data_temporaries.update_all(data_status: params[:approval_status])
        notice = "Source has been #{params[:approval_status]}"
      end

      redirect_to admin_pending_crawl_sources_path, notice: notice
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

    def normalize_company_name(name)
      name.to_s.downcase
        .gsub(/[^a-z0-9]/, "")
        .squeeze(" ")
        .strip
    end
end
