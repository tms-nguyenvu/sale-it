class CrawlDataTemporary < ApplicationRecord
  belongs_to :crawl_source

  enum :data_status, { pending: 0, approved: 1, rejected: 2 }, default: :pending

  scope :pending_review, -> { where(data_status: :pending) }
  scope :expired, -> { where("created_at < ?", 30.days.ago).pending }
end
