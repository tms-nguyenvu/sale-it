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
    # def approve
    #   ActiveRecord::Base.transaction do
    #     @crawl_source.update!(approval_status: :approved)

    #     existing_company_names = Company.pluck(:name).map { |name| normalize_company_name(name) }.to_set

    #     @crawl_source.crawl_data_temporaries.find_each do |temporary_data|
    #       data = temporary_data.data || {}
    #       name = data["name"].to_s.strip
    #       website = data["website"]
    #       industry = data["industry"]

    #       next if name.blank?

    #       normalized_input_name = normalize_company_name(name)

    #       next if existing_company_names.include?(normalized_input_name)

    #       begin
    #         Company.create!(
    #           name: name,
    #           industry: industry,
    #           website: website,
    #           crawl_source_id: @crawl_source.id
    #         )
    #         existing_company_names.add(normalized_input_name)
    #       rescue ActiveRecord::RecordInvalid => e
    #         logger.warn "Skipped company #{name}: #{e.message}"
    #       end
    #     end

    #     @crawl_source.crawl_data_temporaries.update_all(data_status: :approved)
    #   end

    #   flash[:notice] = "Source and related data approved successfully"
    #   redirect_to pending_admin_crawl_sources_path
    # rescue StandardError => e
    #   flash[:alert] = "Error approving source: #{e.message}"
    #   redirect_to pending_admin_crawl_sources_path
    # end


    # def reject
    #   update_approval_status(:rejected)
    # end


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

    # def normalize_company_name(name)
    #   name.to_s.downcase
    #     .gsub(/[^a-z0-9]/, "")
    #     .squeeze(" ")
    #     .strip
    # end
end
