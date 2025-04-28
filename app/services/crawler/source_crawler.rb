module Crawler
  class SourceCrawler
    class << self
      COMMON_SELECTORS = %w[
        main
        .main
        #main
        .container
        #content
        .content
        body
        a
      ].freeze

      def crawl_links(url:)
        html = Crawler::HtmlFetcher.fetch(url: url, headless: false)
        doc = Crawler::HtmlParser.extract_info(html)
        doc.css("a").map { |a| a["href"] }
          .compact
          .reject { |href| href.strip.empty? || href.start_with?("#", "javascript") }
          .uniq
      rescue StandardError => e
        Rails.logger.error("Failed to fetch links from #{url}: #{e.message}")
        raise "Failed to fetch links"
      end

      def crawl_details(detail_paths: [], base_url: nil)
        detail_paths.map do |path|
          full_url = build_full_url(href: path, base_url: base_url)
          html = Crawler::HtmlFetcher.fetch(url: full_url, headless: false)
          doc = Crawler::HtmlParser.extract_info(html)
          find_main_content(doc)
        rescue StandardError => e
          Rails.logger.error("Failed to crawl detail from #{full_url}: #{e.message}")
          raise "Failed to crawl detail"
        end.compact
      end

      private
        def build_full_url(href:, base_url:)
            return href unless href.start_with?("/") && base_url
            URI.join(base_url, href).to_s
        end

        def find_main_content(doc)
          COMMON_SELECTORS.each do |selector|
            element = doc.at_css(selector)
            return element.to_html if element
          end
        end
    end
  end
end
