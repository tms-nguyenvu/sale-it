class Proposal < ApplicationRecord
  enum :status, { sent: 0, archive: 1 }, default: :sent

  belongs_to :template_proposal
  belongs_to :lead

  validates :requirement, :title, presence: true
end
