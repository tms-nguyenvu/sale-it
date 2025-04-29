class Admin::CrawlSourcesController < ApplicationController
    layout "admin"
    before_action :authenticate_user!
    before_action :set_crawl_source, only: [ :show, :edit, :update, :destroy, :approve, :reject ]

    INTERVAL_HOURS = 2.hour

    def index
      @crawl_sources = CrawlSource.all
      @active_sources = CrawlSource.active_sources
      @paused_sources = CrawlSource.paused_sources
      @pending_approval = CrawlSource.pending_approval
      @approved_sources = CrawlSource.approved_sources
      @rejected_sources = CrawlSource.rejected_sources
      @data_temporaries_approved = CrawlDataTemporary.approved_data
      @data_temporaries_pending = CrawlDataTemporary.pending_data
    end

    def show
    end

    def new
    end

    def edit
    end

    def update
      if @crawl_source.update(crawl_source_params)
        flash[:notice] = "Source updated successfully"
        redirect_to admin_crawl_sources_path
      else
        flash[:alert] = "Error updating source"
        render :edit
      end
    end

    def create
      begin
        scheduled = params[:scheduled] == "1" ? true : false
        Crawler::CrawlSourceService.new(params[:source_url], params[:source_type], scheduled).process
        flash[:notice] = "Crawl completed successfully"
        redirect_to pending_admin_crawl_sources_path
      rescue StandardError => e
        flash[:alert] = "Error: #{e.message}"
        redirect_to pending_admin_crawl_sources_path
      end
    end

    def approve
      update_approval_status(:approved)
    end

    def reject
      update_approval_status(:rejected)
    end

    def destroy
      @crawl_source.destroy
      flash[:notice] = "Source deleted successfully"
      redirect_to admin_crawl_sources_path
    end

    def pending
      @crawl_sources = CrawlSource.where(approval_status: :pending)
      render :index
    end

    def history
      @crawl_sources = CrawlSource.all
      render :index
    end

    private

    def set_crawl_source
      @crawl_source = CrawlSource.find(params[:id])
    end

    def crawl_source_params
      params.require(:crawl_source).permit(:source_url, :source_type)
    end

    def update_approval_status(status)
      @crawl_source.update(approval_status: status)
      @crawl_source.crawl_data_temporaries.update_all(data_status: status)

      flash[:notice] = "Source and related data #{status} successfully"
      redirect_to pending_admin_crawl_sources_path
    end
end
