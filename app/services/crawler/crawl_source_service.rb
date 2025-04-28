module Crawler
  class CrawlSourceService
    def initialize(source_url, source_type, scheduled = false)
      @source_url = source_url
      @source_type = source_type
      @scheduled = scheduled
    end

    def process
      all_links = crawl_links
      detail_paths = extract_detail_paths(all_links)
      detail_contents = crawl_details(detail_paths)
      companies = extract_companies(detail_contents)

      if companies.blank?
        raise "An error occurred during the crawl process"
      end

      save_crawl_source_and_companies(companies)
    end

  private

    def crawl_links
      Crawler::SourceCrawler.crawl_links(url: @source_url)
    end

    def extract_detail_paths(all_links)
      batched_links = all_links.each_slice(20).to_a
      detail_paths = []

      batched_links.each_with_index do |links_batch, index|
        link_extraction_prompt = I18n.t(
          "ai.gemini_service.link_extraction_prompt",
          source_url: @source_url,
          links: links_batch.join(", ")
        )

        begin
          filtered_paths = Gemini::GenerateContent.call(prompt: link_extraction_prompt)
          parsed = JSON.parse(filtered_paths)
          detail_paths.concat(parsed)
        rescue JSON::ParserError => e
          Rails.logger.error("[Batch #{index}] Failed to parse detail paths: #{e.message}")
        end
      end

      detail_paths
    end

    def crawl_details(detail_paths)
      Crawler::SourceCrawler.crawl_details(detail_paths: detail_paths, base_url: @source_url)
    end

    def extract_companies(detail_contents)
      company_extraction_prompt = I18n.t(
        "ai.gemini_service.company_extraction_prompt",
        source_type: @source_type,
        details: detail_contents
      )

      Gemini::GenerateContent.call(prompt: company_extraction_prompt)
    end

    def save_crawl_source_and_companies(companies)
      @crawl_sources = CrawlSource.create!(
        source_url: @source_url,
        source_type: @source_type,
        scheduled: @scheduled
      )

      parsed_companies = JSON.parse(companies)
      parsed_companies.each do |company|
        has_valid_data = company.values.any? { |v| !v.nil? }
        if has_valid_data
          @crawl_sources.crawl_data_temporaries.create!(data: company)
        else
          Rails.logger.info("Skipping company with all null values: #{company}")
        end
      end
    end
  end
end
