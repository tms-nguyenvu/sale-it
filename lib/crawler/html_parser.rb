require "nokogiri"

module Crawler
  class HtmlParser
    def self.extract_info(html)
      Nokogiri::HTML(html)
    end
  end
end
