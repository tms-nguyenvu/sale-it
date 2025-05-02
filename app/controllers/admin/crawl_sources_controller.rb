class Admin::CrawlSourcesController < ApplicationController
    layout "admin"
    before_action :authenticate_user!
    before_action :set_crawl_source, only: [ :destroy, :update ]

    INTERVAL_HOURS = 2.hour

    def index
      @crawl_sources = CrawlSource.all
      @active_sources = CrawlSource.active_sources
      @paused_sources = CrawlSource.paused_sources
      @pending_approval = CrawlSource.pending_approval
      @data_temporaries_approved = CrawlDataTemporary.approved_data
      @data_temporaries_pending = CrawlDataTemporary.pending_data
    end

    def create
      begin
        if CrawlSource.find_by(source_url: params[:source_url])
          raise "Source URL already exists"
        end

        scheduled = params[:scheduled] == "1"
        Crawler::CrawlSourceService.new(params[:source_url], params[:source_type], scheduled).process
        redirect_to admin_pending_crawl_sources_path, notice: "Source created successfully"
      rescue StandardError => e
        redirect_to admin_pending_crawl_sources_path, alert: e.message
      end
    end


    def update
      @crawl_source = CrawlSource.find(params[:id])
      if @crawl_source.update(crawl_source_params)
        redirect_to admin_crawl_sources_path, notice: "Crawl source updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @crawl_source.destroy
      redirect_to admin_crawl_sources_path, notice: "Source deleted successfully"
    end

    private

    def set_crawl_source
      @crawl_source = CrawlSource.find(params[:id])
    end

    def crawl_source_params
      params.require(:crawl_source).permit(:source_url, :source_type, :status)
    end
end
