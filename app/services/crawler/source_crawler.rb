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

      INVALID_HREF_PREFIXES = [ "#", "javascript" ].freeze

      def crawl_links(url:)
        doc = fetch_and_parse(url: url)
        doc.css("a").map { |a| a["href"] }
          .compact
          .reject { |href| href.strip.empty? || INVALID_HREF_PREFIXES.any? { |prefix| href.start_with?(prefix) } }
          .uniq
      rescue StandardError => e
        Rails.logger.error("Failed to fetch links from #{url}: #{e.message}")
        raise "Failed to fetch links from #{url}"
      end

      def crawl_details(detail_paths: [], base_url: nil)
        detail_paths.map do |path|
          full_url = build_full_url(href: path, base_url: base_url)
          doc = fetch_and_parse(url: full_url)
          find_main_content(doc)
        rescue StandardError => e
          Rails.logger.error("Failed to crawl detail from #{full_url}: #{e.message}")
          raise "Failed to crawl detail from #{full_url}"
        end.compact
      end

      def crawl_detail_by_url(url:)
        doc = fetch_and_parse(url: url)
        find_main_content(doc)
      rescue StandardError => e
        Rails.logger.error("Failed to crawl detail from #{url}: #{e.message}")
        raise "Failed to crawl detail from #{url}"
      end

      private

        def fetch_and_parse(url:)
          html = Crawler::HtmlFetcher.fetch(url: url, headless: false)
          Crawler::HtmlParser.extract_info(html)
        rescue StandardError => e
          Rails.logger.error("Error fetching or parsing HTML from #{url}: #{e.message}")
          raise "Failed to fetch and parse HTML from #{url}"
        end

        def build_full_url(href:, base_url:)
          return href unless href.start_with?("/") && base_url
          URI.join(base_url, href).to_s
        end

        def find_main_content(doc)
          COMMON_SELECTORS.each do |selector|
            element = doc.at_css(selector)
            next unless element

            element.css("script, style, noscript, iframe, meta").remove
            return element.to_html
          end
          nil
        end
    end
  end
end
