class EmailTracking < ApplicationRecord
  belongs_to :email

  validates :clicked_at, presence: true
end
