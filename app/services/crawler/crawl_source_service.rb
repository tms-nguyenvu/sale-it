module Crawler
  class CrawlSourceService
    def initialize(source_url, source_type, scheduled = false, description = nil)
      @source_url = source_url
      @source_type = source_type
      @scheduled = scheduled
      @description = description
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
      batched_details = detail_contents.each_slice(5).to_a
      all_companies = []

      batched_details.each_with_index do |batch, i|
        company_extraction_prompt = I18n.t(
          "ai.gemini_service.company_extraction_prompt",
          source_type: @source_type,
          details: batch
        )

        begin
          result = Gemini::GenerateContent.call(prompt: company_extraction_prompt)

          # Parse the result and extract only company names
          parsed_result = JSON.parse(result)
          company_names = parsed_result.map { |c| c["name"] }.compact

          company_analyzer_prompt = I18n.t(
            "ai.gemini_service.potential_score_prompt",
            companies: company_names
          )

          enriched_result = Gemini::GenerateContent.call(prompt: company_analyzer_prompt)
          all_companies << JSON.parse(enriched_result)
          sleep(1)
        rescue JSON::ParserError => e
          Rails.logger.error("[Company batch #{i}] Failed to parse company JSON: #{e.message}")
        end
      end

      all_companies.flatten
    end

    def save_crawl_source_and_companies(companies)
      crawl_source = CrawlSource.create!(
        source_url: @source_url,
        source_type: @source_type,
        scheduled: @scheduled,
        description: @description
      )

      companies.each do |company_group|
        company_list = company_group["companies"] || []
        company_list.each do |company|
          cleaned_company = company.compact

          crawl_source.crawl_data_temporaries.create!(data: cleaned_company)
        end
      end
    end
  end
end
