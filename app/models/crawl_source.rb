class CrawlSource < ApplicationRecord
  enum :source_type, { website: 0, api: 1, other: 2 }, default: :other
  enum :status, { active: 0, paused: 1 }, default: :active
  enum :approval_status, { pending: 0, approved: 1, rejected: 2 }, default: :pending

  has_many :companies
  has_many :crawl_data_temporaries, dependent: :destroy

  validates :source_url, :source_type, :status, :approval_status, presence: true

  scope :active_sources, -> { where(status: :active) }
  scope :paused_sources, -> { where(status: :paused) }
  scope :pending_approval, -> { where(approval_status: :pending) }
  scope :approved_sources, -> { where(approval_status: :approved) }
  scope :rejected_sources, -> { where(approval_status: :rejected) }
  scope :scheduled_sources, -> { where(scheduled: true) }
  scope :with_companies, -> { includes(:companies).where.not(companies: { id: nil }) }
end
