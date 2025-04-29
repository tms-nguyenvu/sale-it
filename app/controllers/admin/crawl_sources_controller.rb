module Admin
  class CrawlSourcesController < ApplicationController
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
        if @crawl_sources.find_by(source_url: params[:source_url])
          raise "Source URL already exists"
        end
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
      ActiveRecord::Base.transaction do
        @crawl_source.update!(approval_status: :approved)

        existing_company_names = Company.pluck(:name).map { |name| normalize_company_name(name) }.to_set

        @crawl_source.crawl_data_temporaries.find_each do |temporary_data|
          data = temporary_data.data || {}
          name = data["name"].to_s.strip
          website = data["website"]
          industry = data["industry"]

          next if name.blank?

          normalized_input_name = normalize_company_name(name)

          next if existing_company_names.include?(normalized_input_name)

          begin
            Company.create!(
              name: name,
              industry: industry,
              website: website,
              crawl_source_id: @crawl_source.id
            )
            existing_company_names.add(normalized_input_name)
          rescue ActiveRecord::RecordInvalid => e
            logger.warn "Skipped company #{name}: #{e.message}"
          end
        end

        @crawl_source.crawl_data_temporaries.update_all(data_status: :approved)
      end

      flash[:notice] = "Source and related data approved successfully"
      redirect_to pending_admin_crawl_sources_path
    rescue StandardError => e
      flash[:alert] = "Error approving source: #{e.message}"
      redirect_to pending_admin_crawl_sources_path
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

    def normalize_company_name(name)
      name.to_s.downcase
        .gsub(/[^a-z0-9]/, "")
        .squeeze(" ")
        .strip
    end
  end
end
