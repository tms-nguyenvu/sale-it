class Contact < ApplicationRecord
  belongs_to :company
  include PgSearch::Model
  pg_search_scope :search_full_text,
    against: [ :name, :email ],
    using: {
      tsearch: {
        prefix: true,
        dictionary: "english"
      }
  }
end
