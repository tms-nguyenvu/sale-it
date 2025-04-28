class CrawlDataTemporary < ApplicationRecord
  belongs_to :crawl_source

  enum :data_status, { pending: 0, approved: 1, rejected: 2 }, default: :pending

  scope :pending_data, -> { where(data_status: :pending) }
  scope :approved_data, -> { where(data_status: :approved) }
  scope :last_crawl_data, -> { order(created_at: :desc).first }
end
