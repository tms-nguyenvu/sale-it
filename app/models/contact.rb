class Contact < ApplicationRecord
  include PgSearch::Model

  belongs_to :company
  has_many :emails, dependent: :destroy

  pg_search_scope :search_full_text,
    against: [ :name, :email ],
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english"
      }
  }

  scope :is_decision_maker, -> { where(is_decision_maker: true) }
end
