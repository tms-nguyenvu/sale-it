require "selenium-webdriver"
require "nokogiri"
module Crawler
  class HtmlFetcher
    DEFAULT_WAIT_TIME = 2
    def self.fetch(url:, headless: true)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless") if headless
      options.add_argument("--disable-gpu")
      options.add_argument("--no-sandbox")

      driver = Selenium::WebDriver.for(:chrome, options: options)

      driver.navigate.to(url)
      sleep(DEFAULT_WAIT_TIME)

      html = driver.page_source

      driver.quit
      html
    end
  end
end
