module Crawler
  class SourceCrawler
    def self.crawl_links(url:)
      html = Crawler::HtmlFetcher.fetch(url: url, headless: false)
      doc = Crawler::HtmlParser.extract_info(html)
      doc.css("a").map { |a| a["href"] }.compact.uniq
    rescue StandardError => e
      Rails.logger.error("Failed to fetch links from #{url}: #{e.message}")
    end
  end
end
