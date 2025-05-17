class Proposal < ApplicationRecord
  belongs_to :template_proposal
  belongs_to :lead
end
