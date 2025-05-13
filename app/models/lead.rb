class Lead < ApplicationRecord
  enum :status, { new_lead: 0, sent: 1, replied: 2, demo: 3, negotiate: 4, closed: 5 }, default: :new_lead
  belongs_to :contact
  belongs_to :company
  belongs_to :manager, class_name: "User", optional: true
end
