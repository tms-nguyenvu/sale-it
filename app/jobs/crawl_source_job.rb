class CrawlSourceJob
  include Sidekiq::Worker

  def perform
    total_sources = CrawlSource.scheduled_sources.count
    Rails.logger.info("Total scheduled sources: #{total_sources}")

    CrawlSource.scheduled_sources.find_in_batches(batch_size: 5) do |batch|
    Rails.logger.info("Processing batch of size: #{batch.size}")
      batch.each do |source|
        Rails.logger.info("Enqueuing crawl job for source ID: #{source.id}, URL: #{source.source_url}")
        CrawlSourceWorker.perform_async(source.id)
      end
    end

  Rails.logger.info("Crawl source job completed.")
  end
end
