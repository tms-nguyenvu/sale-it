class Admin::CrawlSourcesController < ApplicationController
    layout "admin"
    before_action :authenticate_user!

    def index
      @crawl_sources = CrawlSource.all
    end

    def create
      source_url = params[:source_url]
      # Crawl all links from the source page
      all_links = Crawler::SourceCrawler.crawl_links(url: source_url)

      # Generate prompt to extract only relevant detail links
      link_extraction_prompt = I18n.t(
        "ai.gemini_service.link_extraction_prompt",
        source_url: source_url,
        links: all_links.join(", ")
      )

      # Use Gemini AI to pick out detail links
      filtered_paths = Gemini::GenerateContent.call(prompt: link_extraction_prompt)
      detail_paths = JSON.parse(filtered_paths)

      # Crawl main content from those detail pages
      detail_contents = Crawler::SourceCrawler.crawl_details(
        detail_paths: detail_paths,
        base_url: source_url
      )

      # Generate prompt to extract company details
      company_extraction_prompt = I18n.t(
        "ai.gemini_service.company_extraction_prompt",
        source_type: params[:source_type],
        details: detail_contents
      )

      # Use Gemini AI to extract company details
      companies = Gemini::GenerateContent.call(prompt: company_extraction_prompt)

      puts companies
    end

    def pending
      @crawl_sources = CrawlSource.where(approval_status: :pending)
      render :index
    end

    private
      def crawl_source_params
        params.require(:crawl_source).permit(:source_url, :source_type, :status, :approval_status)
      end
end
