class Email < ApplicationRecord
  enum status: { draft: 0, scheduled: 1, sent: 2, delivered: 3, failed: 4 }, default: :draft
  enum email_type: { initial: 0, followup: 1, reminder: 2 }, default: :initial
  enum tone: { professional: 0, friendly: 1, casual: 2, formal: 3 }, default: :professional

  belongs_to :campaign
  belongs_to :contact
  has_many :email_stats, dependent: :destroy

  validates :subject, :content, presence: true
end
