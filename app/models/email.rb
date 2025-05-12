class Email < ApplicationRecord
  enum :status, { draft: 0, scheduled: 1, sent: 2, delivered: 3, failed: 4 }, default: :draft
  enum :email_type, { initial: 0, followup: 1, reminder: 2 }, default: :initial
  enum :tone, { professional: 0, friendly: 1, casual: 2, formal: 3 }, default: :professional

  belongs_to :contact
  belongs_to :user
  has_many :email_trackings, dependent: :destroy
  has_many :email_replies, dependent: :destroy


  validates :subject, :body, presence: true

  def self.ransackable_associations(auth_object = nil)
    %w[contact]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "subject" ]
  end
end
