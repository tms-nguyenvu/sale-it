class DeletePendingRejectedSourcesJob
  include Sidekiq::Worker

  def perform
    CrawlSource.where.not(approval_status: "approved").destroy_all
    Rails.logger.info "Deleted pending/rejected sources"
  end
end
