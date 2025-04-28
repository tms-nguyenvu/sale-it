class CrawlSourceWorker
  include Sidekiq::Worker

  def perform(source_id)
    source = CrawlSource.find(source_id)
    if source.approval_status == "approved"
      Crawler::CrawlSourceService.new(source.source_url, source.source_type).process
    end
  end
end
